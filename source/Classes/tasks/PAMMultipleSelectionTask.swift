//
//  PAMMultipleSelectionTask.swift
//  SDLRKX
//
//  Created by James Kizer on 10/10/16.
//  Copyright © 2016 Foundry @ Cornell Tech. All rights reserved.
//

import UIKit
import ResearchKit

open class PAMMultipleSelectionTask: RKXMultipleImageSelectionSurveyTask {
    class func defaultOptions() -> RKXMultipleImageSelectionSurveyOptions {
        let options = RKXMultipleImageSelectionSurveyOptions()
        options.somethingSelectedButtonColor = UIColor.blue
        options.nothingSelectedButtonColor = UIColor.blue
        options.itemsPerRow = 4
        options.itemMinSpacing = 4
        return options
    }
    
    convenience public init(identifier: String) {
        
        self.init(identifier: identifier, propertiesFileName: "PAM", bundle: Bundle(for: PAMMultipleSelectionTask.self))
    }
    
    convenience init(identifier: String, propertiesFileName: String, bundle: Bundle = Bundle.main) {
        
        guard let filePath = bundle.path(forResource: propertiesFileName, ofType: "json")
            else {
                fatalError("Unable to locate file PAM.json")
        }
        
        guard let fileContent = try? Data(contentsOf: URL(fileURLWithPath: filePath))
            else {
                fatalError("Unable to create NSData with file content (PAM data)")
        }
        
        let spotAssessmentParameters = try! JSONSerialization.jsonObject(with: fileContent, options: JSONSerialization.ReadingOptions.mutableContainers)
        
        self.init(identifier: identifier, json: spotAssessmentParameters as AnyObject, bundle: bundle)
    }
    
    convenience public init(identifier: String, json: AnyObject, bundle: Bundle = Bundle.main) {
        
        
        guard let completeJSON = json as? [String: AnyObject],
            let typeJSON = completeJSON["PAM"] as? [String: AnyObject],
            let itemJSONArray = typeJSON["affects"] as? [AnyObject]
            else {
                fatalError("JSON Parse Error")
        }
        
        let assessmentJSON = typeJSON
        let items:[RKXSingleImageAffectDescriptor] = itemJSONArray.map { (itemJSON: AnyObject) in
            guard let itemDictionary = itemJSON as? [String: AnyObject]
                else
            {
                return nil
            }
            return RKXSingleImageAffectDescriptor(itemDictionary: itemDictionary)
            }.flatMap { $0 }
        
        let imageChoices: [ORKImageChoice] = items
            .map(RKXImageDescriptor.imageChoiceForDescriptor(bundle))
            //dont forget to unwrap optionals!!
            .flatMap { $0 }
        
        let assessment = RKXMultipleImageSelectionSurveyDescriptor(assessmentDictionary: assessmentJSON)
        
        let steps: [ORKStep] = {
            if (imageChoices.count == 0) {
                guard let noActivitiesSummary = assessment.noItemsSummary
                    else {
                        fatalError("No activities and no activity summary")
                }
                let summaryStep = ORKInstructionStep(identifier: noActivitiesSummary.identifier)
                summaryStep.title = noActivitiesSummary.title
                summaryStep.text = noActivitiesSummary.text
                return [summaryStep]
            }
            else {
                
                let answerFormat = ORKAnswerFormat.choiceAnswerFormat(with: imageChoices)
                
                let pamStep = PAMMultipleSelectionStep(identifier: identifier, title: assessment.prompt, answerFormat: answerFormat, options: PAMMultipleSelectionTask.defaultOptions())
                
                var steps: [ORKStep] = [pamStep]
                
                if let summary = assessment.summary {
                    let summaryStep = ORKInstructionStep(identifier: summary.identifier)
                    summaryStep.title = summary.title
                    summaryStep.text = summary.text
                    steps.append(summaryStep)
                }
                
                return steps
            }
        }()
        
        self.init(identifier: identifier, steps: steps)
        
    }
    
    override init(identifier: String, steps: [ORKStep]?) {
        super.init(identifier: identifier, steps: steps)
    }
    
    required public init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
