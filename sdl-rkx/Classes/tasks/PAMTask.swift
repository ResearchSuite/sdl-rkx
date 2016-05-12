//
//  PAMTask.swift
//  sdl-rkx
//
//  Created by James Kizer on 5/3/16.
//  Copyright © 2016 Cornell Tech Foundry. All rights reserved.
//

import UIKit
import ResearchKit

public class PAMTask: RKXMultipleImageSelectionSurveyTask {

    class func defaultOptions() -> RKXMultipleImageSelectionSurveyOptions {
        let options = RKXMultipleImageSelectionSurveyOptions()
        options.somethingSelectedButtonColor = UIColor.blueColor()
        options.nothingSelectedButtonColor = UIColor.blueColor()
        options.itemsPerRow = 4
        options.itemMinSpacing = 4
        return options
    }
    
    convenience public init(identifier: String) {
        
        self.init(identifier: identifier, propertiesFileName: "PAM", bundle: NSBundle(forClass: PAMTask.self))
    }
    
    convenience init(identifier: String, propertiesFileName: String, bundle: NSBundle = NSBundle.mainBundle()) {
        
        guard let filePath = bundle.pathForResource(propertiesFileName, ofType: "json")
            else {
                fatalError("Unable to locate file PAM.json")
        }
        
        guard let fileContent = NSData(contentsOfFile: filePath)
            else {
                fatalError("Unable to create NSData with file content (PAM data)")
        }
        
        let spotAssessmentParameters = try! NSJSONSerialization.JSONObjectWithData(fileContent, options: NSJSONReadingOptions.MutableContainers)
        
        self.init(identifier: identifier, json: spotAssessmentParameters, bundle: bundle)
    }
    
    convenience init(identifier: String, json: AnyObject, bundle: NSBundle = NSBundle.mainBundle()) {
        
        
        guard let completeJSON = json as? [String: AnyObject],
            let typeJSON = completeJSON["PAM"] as? [String: AnyObject],
            let assessmentJSON = typeJSON as? [String: AnyObject],
            let itemJSONArray = typeJSON["affects"] as? [AnyObject]
            else {
                fatalError("JSON Parse Error")
        }
        
        let items:[RKXAffectDescriptor] = itemJSONArray.map { (itemJSON: AnyObject) in
            guard let itemDictionary = itemJSON as? [String: AnyObject]
                else
            {
                return nil
            }
            return RKXAffectDescriptor(itemDictionary: itemDictionary)
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
                
                let answerFormat = ORKAnswerFormat.choiceAnswerFormatWithImageChoices(imageChoices)
                
                let pamStep = PAMStep(identifier: identifier, title: assessment.prompt, answerFormat: answerFormat)
                
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
        self.options = PAMTask.defaultOptions()
        
    }
    
    override init(identifier: String, steps: [ORKStep]?) {
        super.init(identifier: identifier, steps: steps)
    }
    
    required public init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
