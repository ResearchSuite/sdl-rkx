//
//  CTFBARTStepGenerator.swift
//  Impulse
//
//  Created by James Kizer on 12/20/16.
//  Copyright © 2016 Cornell Tech. All rights reserved.
//

import UIKit
import ResearchSuiteTaskBuilder
import ResearchKit
import Gloss

open class CTFBARTStepGenerator: RSTBBaseStepGenerator {
    
    public init(){}
    
    let _supportedTypes = [
        "CTFBARTActiveStep"
    ]
    
    public var supportedTypes: [String]! {
        return self._supportedTypes
    }
    
    open func generateStep(type: String, jsonObject: JSON, helper: RSTBTaskBuilderHelper) -> ORKStep? {
        
        guard let customStepDescriptor = helper.getCustomStepDescriptor(forJsonObject: jsonObject),
            let parameters = customStepDescriptor.parameters,
            let stepParamDescriptor = CTFBARTStepParamsDescriptor(json: parameters ) else {
                return nil
        }
        
        let stepParams = CTFBARTStepParams(
            numTrials: stepParamDescriptor.numTrials,
            earningsPerPump: stepParamDescriptor.earningsPerPump,
            maxPayingPumpsPerTrial: stepParamDescriptor.maxPayingPumpsPerTrial,
            canExplodeOnFirstPump: stepParamDescriptor.canExplodeOnFirstPump)
        
        let step = CTFBARTStep(identifier: customStepDescriptor.identifier)
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
