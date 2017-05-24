//
//  RSQuestionTableViewController.swift
//  Pods
//
//  Created by James Kizer on 4/6/17.
//
//

import UIKit
import ResearchKit
import ResearchSuiteTaskBuilder
import Gloss

open class RSQuestionTableViewStepGenerator: RSTBBaseStepGenerator {
    
    public init(){}
    
    let _supportedTypes = [
        "RSQuestionTableViewController"
    ]
    
    public var supportedTypes: [String]! {
        return self._supportedTypes
    }
    
    open func generateStep(type: String, jsonObject: JSON, helper: RSTBTaskBuilderHelper) -> ORKStep? {
        
//        guard let customStepDescriptor = helper.getCustomStepDescriptor(forJsonObject: jsonObject),
//            let parameters = customStepDescriptor.parameters,
//            let semanticDifferentialFormParameters = CTFSemanticDifferentialScaleFormParameters(json: parameters ) else {
//                return nil
//        }
        
        guard let stepDescriptor = RSTBStepDescriptor(json: jsonObject) else {
            return nil
        }
        
        //generate form items from question step descriptors
//        let formItems = semanticDifferentialFormParameters.items.flatMap { (formItemDescriptor) -> ORKFormItem? in
//            
//            let answerFormat = CTFSemanticDifferentialScaleAnswerFormat(withMaximumValue: formItemDescriptor.maximum, minimumValue: formItemDescriptor.minimum, defaultValue: formItemDescriptor.defaultValue, step: formItemDescriptor.step, vertical: false, maximumValueDescription: formItemDescriptor.maxValueText, minimumValueDescription: formItemDescriptor.minValueText, trackHeight: formItemDescriptor.trackHeight, gradientColors: formItemDescriptor.gradientColors)
//            return ORKFormItem(identifier: formItemDescriptor.identifier, text: formItemDescriptor.text, answerFormat: answerFormat, optional: formItemDescriptor.optional)
//            
//        }
//        let formStep = CTFPulsusFormStep(identifier: customStepDescriptor.identifier, title: semanticDifferentialFormParameters.title, text: semanticDifferentialFormParameters.text)
//        formStep.formItems = formItems
//        return formStep
        
        let step = RSQuestionTableViewStep(identifier: stepDescriptor.identifier)
        step.title = stepDescriptor.title
        step.text = stepDescriptor.text
        step.isOptional = stepDescriptor.optional
        return step
    }
    
    open func processStepResult(type: String,
                                jsonObject: JsonObject,
                                result: ORKStepResult,
                                helper: RSTBTaskBuilderHelper) -> JSON? {
        return nil
    }

}
