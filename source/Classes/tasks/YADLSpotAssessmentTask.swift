//
//  YADLSpotAssessmentTask.swift
//  sdlrkx
//
//  Created by James Kizer on 4/5/16.
//  Copyright © 2016 Cornell Tech Foundry. All rights reserved.
//

import UIKit
import ResearchKit

open class YADLSpotAssessmentTask: RKXMultipleImageSelectionSurveyTask {
    
//    public class func spotAssessmentResults(taskResult: ORKTaskResult) -> [ORKChoiceQuestionResult]? {
//        if let stepResults = taskResult.results as? [ORKStepResult]
//        {
//            return stepResults.map { stepResult in
//                return stepResult.firstResult as? ORKChoiceQuestionResult
//                }
//                .flatMap{ $0 }
//        }
//        else { return nil }
//    }
    
    convenience public init(identifier: String, propertiesFileName: String, activityIdentifiers: [String]? = nil) {

        guard let filePath = Bundle.main.path(forResource: propertiesFileName, ofType: "json")
            else {
                fatalError("Unable to location file with YADL Spot Assessment Section in main bundle")
        }
        
        guard let fileContent = try? Data(contentsOf: URL(fileURLWithPath: filePath))
            else {
                fatalError("Unable to create NSData with file content (YADL Spot Assessment data)")
        }
        
        let spotAssessmentParameters = try! JSONSerialization.jsonObject(with: fileContent, options: JSONSerialization.ReadingOptions.mutableContainers)
        
        self.init(identifier: identifier, json: spotAssessmentParameters as AnyObject, activityIdentifiers: activityIdentifiers)
    }
    
    convenience public init(identifier: String, json: AnyObject, activityIdentifiers: [String]? = nil) {

        guard let completeJSON = json as? [String: AnyObject],
            let typeJSON = completeJSON["YADL"] as? [String: AnyObject],
            let assessmentJSON = typeJSON["spot"] as? [String: AnyObject],
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
        
        let imageChoices: [ORKImageChoice] = items
            .filter { activity in
                if let identifiers = activityIdentifiers {
                    return identifiers.contains(activity.identifier)
                }
                else {
                    return true
                }
            }
            .map(RKXImageDescriptor.imageChoiceForDescriptor())
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
                
                let spotAssessmentStep = YADLSpotAssessmentStep(identifier: identifier, title: assessment.prompt, answerFormat: answerFormat, options: assessment.options)
                
                var steps: [ORKStep] = [spotAssessmentStep]
                
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
