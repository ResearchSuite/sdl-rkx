    //
//  YADLFullStepGenerator.swift
//  Pods
//
//  Created by James Kizer on 4/2/17.
//
//

import UIKit
import ResearchSuiteTaskBuilder
import ResearchKit
import Gloss

open class YADLFullStepGenerator: RSTBBaseStepGenerator {
    
    public init(){}
    
    let _supportedTypes = [
        "YADLFullAssessment"
    ]
    
    public var supportedTypes: [String]! {
        return self._supportedTypes
    }
    
    open func generateSteps(type: String, jsonObject: JSON, helper: RSTBTaskBuilderHelper) -> [ORKStep]? {
        
        guard let yadlFullDescriptor = YADLFullStepDescriptor(json: jsonObject) else {
            return nil
        }
        
        let textChoices: [ORKTextChoice] = yadlFullDescriptor.choices.flatMap { (choice) -> ORKTextChoice? in
            RKXTextChoiceWithColor(text: choice.text, value: choice.value as NSCoding & NSCopying & NSObjectProtocol, color: choice.color)
        }
        
        let answerFormat = ORKAnswerFormat.choiceAnswerFormat(with: .singleChoice, textChoices: textChoices)
        
        return yadlFullDescriptor.items.flatMap({ (item) -> YADLFullAssessmentStep? in
            guard let image = UIImage(named: item.imageTitle)
                else {
                    assertionFailure("Cannot find image named \(item.imageTitle)")
                    return nil
            }
            
            let step = YADLFullAssessmentStep(identifier: yadlFullDescriptor.identifier.appending(".\(item.identifier)"), title: item.description, text: yadlFullDescriptor.text, image: image, answerFormat: answerFormat)
            step.isOptional = yadlFullDescriptor.optional
            return step
        })
    }
    
    open func processStepResult(type: String,
                                jsonObject: JsonObject,
                                result: ORKStepResult,
                                helper: RSTBTaskBuilderHelper) -> JSON? {
        return nil
    }

}
