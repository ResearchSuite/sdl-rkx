//
//  RKXSingleImageClassificationSurveyTask.swift
//  Pods
//
//  Created by James Kizer on 5/2/16.
//
//

import UIKit
import ResearchKit

public class RKXSingleImageClassificationSurveyTask: ORKOrderedTask {

//    public required init(identifier: String,
//                     prompt: String,
//                     choices: [ChoiceStruct],
//                     items: [ItemStruct],
//                     summary: SummaryStruct,
//                     noActivitiesSummary: SummaryStruct) {
//        
//        if items.count == 0 {
//            let summaryStep = ORKInstructionStep(identifier: noActivitiesSummary.identifier)
//            summaryStep.title = noActivitiesSummary.title
//            summaryStep.text = noActivitiesSummary.text
//            super.init(identifier: identifier, steps: [summaryStep])
//        }
//        else {
//            
//            
//            
//            let textChoices = choices.map { choice in
//                return RKXTextChoiceWithColor(text: choice.text, value: choice.value, color: choice.color)
//            }
//            
//            let answerFormat = ORKAnswerFormat.choiceAnswerFormatWithStyle(.SingleChoice, textChoices: textChoices)
//            var steps: [ORKStep] = items.map { item in
//                return RKXSingleImageClassificationSurveyStep(identifier: item.identifier, title: item.description, text: prompt, image: item.image, answerFormat: answerFormat)
//            }
//            
//            let summaryStep = ORKInstructionStep(identifier: summary.identifier)
//            summaryStep.title = summary.title
//            summaryStep.text = summary.text
//            
//            steps.append(summaryStep)
//            
//            super.init(identifier: identifier, steps: steps)
//        }
//    }
//    
//    required public init(coder aDecoder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
    
}
