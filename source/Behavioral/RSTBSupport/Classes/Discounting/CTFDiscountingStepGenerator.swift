//
//  CTFDelayDiscountingStepGenerator.swift
//  Impulse
//
//  Created by James Kizer on 12/20/16.
//  Copyright © 2016 Cornell Tech. All rights reserved.
//

import UIKit
import ResearchSuiteTaskBuilder
import ResearchKit
import Gloss

open class CTFDiscountingStepGenerator: RSTBBaseStepGenerator {
    
    public init(){}
    
    let _supportedTypes = [
        "CTFDiscountingActiveStep"
    ]
    
    public var supportedTypes: [String]! {
        return self._supportedTypes
    }
    
    open func generateStep(type: String, jsonObject: JSON, helper: RSTBTaskBuilderHelper) -> ORKStep? {
        
        guard let stepDescriptor = CTFDiscountingDescriptor(json: jsonObject ) else {
                return nil
        }
        
        let step = CTFDiscountingStep(
            identifier: stepDescriptor.identifier,
            text: stepDescriptor.text!,
            constantAmount: stepDescriptor.constantAmount,
            initialVariableAmount: stepDescriptor.initialVariableAmount,
            numQuestions: stepDescriptor.numQuestions,
            constantFormatString: stepDescriptor.constantFormatString,
            variableFormatString: stepDescriptor.variableFormatString
        )

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
