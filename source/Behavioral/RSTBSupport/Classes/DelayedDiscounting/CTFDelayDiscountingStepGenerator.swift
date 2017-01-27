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

open class CTFDelayDiscountingStepGenerator: RSTBBaseStepGenerator {
    
    public init(){}
    
    let _supportedTypes = [
        "CTFDelayedDiscountingActiveStep"
    ]
    
    public var supportedTypes: [String]! {
        return self._supportedTypes
    }
    
    open func generateStep(type: String, jsonObject: JSON, helper: RSTBTaskBuilderHelper) -> ORKStep? {
        
        guard let customStepDescriptor = helper.getCustomStepDescriptor(forJsonObject: jsonObject),
            let parameters = customStepDescriptor.parameters,
            let stepParamDescriptor = CTFDelayDiscountingParamsDescriptor(json: parameters ) else {
                return nil
        }
        
        let stepParams = CTFDelayDiscountingStepParams(maxAmount: stepParamDescriptor.maxAmount, numQuestions: stepParamDescriptor.numQuestions, nowDescription: stepParamDescriptor.nowDescription, laterDescription: stepParamDescriptor.laterDescription, formatString: stepParamDescriptor.formatString, prompt: stepParamDescriptor.prompt)
        
        let step = CTFDelayDiscountingStep(identifier: customStepDescriptor.identifier)
        step.params = stepParams
        step.isOptional = customStepDescriptor.optional
        
        return step
    }
    
    open func processStepResult(type: String,
                                jsonObject: JsonObject,
                                result: ORKStepResult,
                                helper: RSTBTaskBuilderHelper) -> JSON? {
        return nil
    }
    
}
