//
//  RSEnhancedMultipleChoiceStepGenerator.swift
//  Pods
//
//  Created by James Kizer on 4/8/17.
//
//

import UIKit
import ResearchKit
import ResearchSuiteTaskBuilder
import Gloss

open class RSEnhancedChoiceStepGenerator: RSTBBaseStepGenerator {
    
    open var allowsMultiple: Bool {
        fatalError("abstract class not implemented")
    }
    
    open var supportedTypes: [String]! {
        return nil
    }
    
    public typealias ChoiceItemFilter = ( (RSEnhancedChoiceItemDescriptor) -> (Bool))
    
    open func generateFilter(type: String, jsonObject: JSON, helper: RSTBTaskBuilderHelper) -> ChoiceItemFilter? {
        
        return { choiceItem in
            return true
        }
    }
    
    open func generateChoices(items: [RSEnhancedChoiceItemDescriptor], valueSuffix: String?, shouldShuffle: Bool?, helper: RSTBTaskBuilderHelper) -> [RSTextChoiceWithAuxiliaryAnswer] {
        
        let shuffledItems = items.shuffled(shouldShuffle: shouldShuffle ?? false)
        
        return shuffledItems.map { item in
            
            let value: NSCoding & NSCopying & NSObjectProtocol = ({
                if let suffix = valueSuffix,
                    let stringValue = item.value as? String {
                    return (stringValue + suffix) as NSCoding & NSCopying & NSObjectProtocol
                }
                else {
                    return item.value
                }
            }) ()
            
            let auxiliaryItem: ORKFormItem? = {
                
                guard let auxiliaryItem = item.auxiliaryItem,
                    let stepDescriptor = RSTBStepDescriptor(json: auxiliaryItem),
                    let builder = helper.builder,
                    let answerFormat = builder.generateAnswerFormat(type: stepDescriptor.type, jsonObject: auxiliaryItem, helper: helper) else {
                    return nil
                }

                let formItem = ORKFormItem(
                    identifier: stepDescriptor.identifier,
                    text: stepDescriptor.text,
                    answerFormat: answerFormat,
                    optional: stepDescriptor.optional
                )
                
                formItem.placeholder = "placeholder" <~~ auxiliaryItem
                
                return formItem
                
            }()
            
            return RSTextChoiceWithAuxiliaryAnswer(
                text: item.text,
                detailText: item.detailText,
                value: value,
                exclusive: item.exclusive,
                auxiliaryItem: auxiliaryItem)
        }
    }
    
    open func generateAnswerFormat(type: String, jsonObject: JSON, helper: RSTBTaskBuilderHelper) -> ORKTextChoiceAnswerFormat? {
        guard let choiceStepDescriptor:RSTBChoiceStepDescriptor<RSEnhancedChoiceItemDescriptor> = RSTBChoiceStepDescriptor(json: jsonObject) else {
            return nil
        }
        
        let filteredItems: [RSEnhancedChoiceItemDescriptor] = {
            
            if let itemFilter = self.generateFilter(type: type, jsonObject: jsonObject, helper: helper) {
                return choiceStepDescriptor.items.filter(itemFilter)
            }
            else {
                return choiceStepDescriptor.items
            }
            
        }()
        
        let choices = self.generateChoices(items: filteredItems, valueSuffix: choiceStepDescriptor.valueSuffix, shouldShuffle: choiceStepDescriptor.shuffleItems, helper: helper)
        
        guard choices.count > 0 else {
            return nil
        }
        
        let answerFormat = ORKAnswerFormat.choiceAnswerFormat(
            with: self.allowsMultiple ? ORKChoiceAnswerStyle.multipleChoice : ORKChoiceAnswerStyle.singleChoice,
            textChoices: choices
        )
        
        return answerFormat
    }
    
    open func generateStep(type: String, jsonObject: JSON, helper: RSTBTaskBuilderHelper) -> ORKStep? {
        guard let answerFormat = self.generateAnswerFormat(type: type, jsonObject: jsonObject, helper: helper),
            let questionStepDescriptor = RSTBQuestionStepDescriptor(json: jsonObject) else {
                return nil
        }
        
        let step = RSEnhancedMultipleChoiceStep(
            identifier: questionStepDescriptor.identifier,
            title: questionStepDescriptor.title,
            text: questionStepDescriptor.text,
            answer: answerFormat)
        
        step.isOptional = questionStepDescriptor.optional
        return step
    }
    
    open func processStepResult(type: String,
                                jsonObject: JsonObject,
                                result: ORKStepResult,
                                helper: RSTBTaskBuilderHelper) -> JSON? {
        
        return nil
    }
    
//    open override func processQuestionResult(type: String, result: ORKQuestionResult, helper: RSTBTaskBuilderHelper) -> JSON? {
//        
//        if let result = result as? ORKChoiceQuestionResult,
//            let choices = result.choiceAnswers as? [NSCoding & NSCopying & NSObjectProtocol] {
//            return [
//                "identifier": result.identifier,
//                "type": type,
//                "answer": choices
//            ]
//        }
//        return  nil
//    }
    
}

open class RSEnhancedSingleChoiceStepGenerator: RSEnhancedChoiceStepGenerator {
    
    public override init(){}
    
    override open var supportedTypes: [String]! {
        return ["enhancedSingleChoiceText"]
    }
    
    override open var allowsMultiple: Bool {
        return false
    }
    
}

open class RSEnhancedMultipleChoiceStepGenerator: RSEnhancedChoiceStepGenerator {
    
    public override init(){}
    
    override open var supportedTypes: [String]! {
        return ["enhancedMultipleChoiceText"]
    }
    
    override open var allowsMultiple: Bool {
        return true
    }
}
