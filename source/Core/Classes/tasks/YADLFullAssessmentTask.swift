//
//  YADLFullAssessmentTask.swift
//  sdlrkx
//
//  Created by James Kizer on 4/5/16.
//  Copyright © 2016 Cornell Tech Foundry. All rights reserved.
//

import UIKit
import ResearchKit

open class YADLFullAssessmentTask: RKXSingleImageClassificationSurveyTask {

    open class func fullAssessmentResults(_ taskResult: ORKTaskResult) -> [ORKChoiceQuestionResult]? {
        if let stepResults = taskResult.results as? [ORKStepResult]
        {
            return stepResults.map { stepResult in
                return stepResult.firstResult as? ORKChoiceQuestionResult
                }
                .flatMap{ $0 }
        }
        else { return nil }
    }
    
    required public init(identifier: String, json: AnyObject) {

        guard let completeJSON = json as? [String: AnyObject],
        let typeJSON = completeJSON["YADL"] as? [String: AnyObject],
        let assessmentJSON = typeJSON["full"] as? [String: AnyObject],
        let itemJSONArray = typeJSON["activities"] as? [AnyObject]
            else {
                fatalError("JSON Parse Error")
        }
        
        let items:[RKXActivityDescriptor] = itemJSONArray.map { (itemJSON: AnyObject) in
            guard let itemDictionary = itemJSON as? [String: AnyObject]
                else
                {
                return nil
            }
            return RKXActivityDescriptor(itemDictionary: itemDictionary)
        }.flatMap { $0 }
        
        let assessment = YADLFullAssessmentDescriptor(assessmentDictionary: assessmentJSON)
        
        if items.count == 0 {
            guard let noActivitiesSummary = assessment.noItemsSummary
                else {
                    fatalError("No activities and no activity summary")
            }
            let summaryStep = ORKInstructionStep(identifier: noActivitiesSummary.identifier)
            summaryStep.title = noActivitiesSummary.title
            summaryStep.text = noActivitiesSummary.text
            super.init(identifier: identifier, steps: [summaryStep])
        }
        else {
            let textChoices = assessment.choices!.map { choice in
                return RKXTextChoiceWithColor(text: choice.text, value: (choice.value)!, color: choice.color)
            }
            
            let answerFormat = ORKAnswerFormat.choiceAnswerFormat(with: .singleChoice, textChoices: textChoices)
            var steps: [ORKStep] = items.map { item in
                guard let image = UIImage(named: item.imageTitle)
                    else {
                        fatalError("Cannot find image named \(item.imageTitle)")
                }
                return YADLFullAssessmentStep(identifier: item.identifier, title: item.activityDescription, text: assessment.prompt, image: image, answerFormat: answerFormat)
            }
            
            if let summary = assessment.summary {
                let summaryStep = ORKInstructionStep(identifier: summary.identifier)
                summaryStep.title = summary.title
                summaryStep.text = summary.text
                
                steps.append(summaryStep)
            }
            
            super.init(identifier: identifier, steps: steps)
        }
    }
    
    convenience public init(identifier: String, propertiesFileName: String) {
        
        guard let filePath = Bundle.main.path(forResource: propertiesFileName, ofType: "json")
            else {
                fatalError("Unable to location file with YADL Full Assessment Section in main bundle")
        }
        
        guard let fileContent = try? Data(contentsOf: URL(fileURLWithPath: filePath))
            else {
                fatalError("Unable to create NSData with file content (YADL Full Assessment data)")
        }
        
        let spotAssessmentParameters = try! JSONSerialization.jsonObject(with: fileContent, options: JSONSerialization.ReadingOptions.mutableContainers)
        
        self.init(identifier: identifier, json: spotAssessmentParameters as AnyObject)
    }
    
    required public init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}
