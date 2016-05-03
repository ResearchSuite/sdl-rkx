//
//  YADLFullAssessmentTask.swift
//  YADL
//
//  Created by James Kizer on 4/5/16.
//  Copyright © 2016 Cornell Tech Foundry. All rights reserved.
//

import UIKit
import ResearchKit

public class YADLFullAssessmentTask: RKXSingleImageClassificationSurveyTask {

    public class func fullAssessmentResults(taskResult: ORKTaskResult) -> [ORKChoiceQuestionResult]? {
        if let stepResults = taskResult.results as? [ORKStepResult]
        {
            return stepResults.map { stepResult in
                return stepResult.firstResult as? ORKChoiceQuestionResult
                }
                .flatMap{ $0 }
        }
        else { return nil }
    }
    
    //note that this is a Class method, the steps array needs to be passed to the init function
    class func loadStepsFromJSON(jsonParser: RKXJSONParser) -> [ORKStep]? {
        
        guard let identifier = jsonParser.YADLFullAssessmentIdentifier
            else {
                fatalError("Missing or Malformed Prompt")
        }
        
        guard let prompt = jsonParser.YADLFullAssessmentPrompt
            else {
                fatalError("Missing or Malformed Prompt")
        }
        
        guard let choices = jsonParser.YADLFullAssessmentChoices
            else {
                fatalError("Missing or Malformed Choices")
        }
        
        guard let activities = jsonParser.activities
            else {
                fatalError("Missing or Malformed Activities")
        }
        
        guard let summary = jsonParser.YADLFullAssessmentSummary
            else {
                fatalError("Missing or Malformed Summary")
        }
        
        guard let noActivitiesSummary = jsonParser.YADLFullAssessmentNoActivitiesSummary
            else {
                fatalError("Missing or Malformed No Activities Summary")
        }
        
        if activities.count == 0 {
            let summaryStep = ORKInstructionStep(identifier: kYADLFullAssessmentSummaryID)
            summaryStep.title = noActivitiesSummary.title
            summaryStep.text = noActivitiesSummary.text
            return [summaryStep]
        }
        
        let textChoices = choices.map { choice in
            return RKXTextChoiceWithColor(text: choice.text, value: choice.value, color: choice.color)
        }
        
        let answerFormat = ORKAnswerFormat.choiceAnswerFormatWithStyle(.SingleChoice, textChoices: textChoices)
        
        var steps: [ORKStep] = activities.map { activity in
            
            return RKXSingleImageClassificationSurveyStep(identifier: activity.identifier, title: activity.description, text: prompt, image: activity.image, answerFormat: answerFormat)
            
        }
        
        let summaryStep = ORKInstructionStep(identifier: kYADLFullAssessmentSummaryID)
        summaryStep.title = summary.title
        summaryStep.text = summary.text
        
        steps.append(summaryStep)
        
        return steps
    }
    
    convenience public init(identifier: String, json: AnyObject) {
        
        let jsonParser = RKXJSONParser(json: json)
        
        guard let identifier = jsonParser.YADLFullAssessmentIdentifier
            else {
                fatalError("Missing or Malformed Prompt")
        }
        
        guard let prompt = jsonParser.YADLFullAssessmentPrompt
            else {
                fatalError("Missing or Malformed Prompt")
        }
        
        guard let choices = jsonParser.YADLFullAssessmentChoices
            else {
                fatalError("Missing or Malformed Choices")
        }
        
        guard let activities = jsonParser.activities
            else {
                fatalError("Missing or Malformed Activities")
        }
        
        guard let summary = jsonParser.YADLFullAssessmentSummary
            else {
                fatalError("Missing or Malformed Summary")
        }
        
        guard let noActivitiesSummary = jsonParser.YADLFullAssessmentNoActivitiesSummary
            else {
                fatalError("Missing or Malformed No Activities Summary")
        }
        
        self.init(identifier: identifier, prompt: prompt, choices: choices, items: activities, summary: summary, noActivitiesSummary: noActivitiesSummary)
    }
    
    convenience public init(identifier: String, propertiesFileName: String) {
        
        guard let filePath = NSBundle.mainBundle().pathForResource(propertiesFileName, ofType: "json")
            else {
                fatalError("Unable to location file with YADL Full Assessment Section in main bundle")
        }
        
        guard let fileContent = NSData(contentsOfFile: filePath)
            else {
                fatalError("Unable to create NSData with file content (YADL Full Assessment data)")
        }
        
        let spotAssessmentParameters = try! NSJSONSerialization.JSONObjectWithData(fileContent, options: NSJSONReadingOptions.MutableContainers)
        
        self.init(identifier: identifier, json: spotAssessmentParameters)
    }
    
    required public init(identifier: String,
                  prompt: String,
                  choices: [ChoiceStruct],
                  items: [ItemStruct],
                  summary: SummaryStruct,
                  noActivitiesSummary: SummaryStruct) {
        super.init(identifier: identifier, prompt: prompt, choices: choices, items: items, summary: summary, noActivitiesSummary: noActivitiesSummary)
    }
    
    required public init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}
