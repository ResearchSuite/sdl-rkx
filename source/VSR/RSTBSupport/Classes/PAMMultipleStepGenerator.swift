//
//  PAMMultipleStepGenerator.swift
//  Pods
//
//  Created by James Kizer on 2/26/17.
//
//

import UIKit
import ResearchSuiteTaskBuilder
import ResearchKit
import sdlrkx
import Gloss

public class PAMMultipleStepGenerator: RSTBBaseStepGenerator {
    
    public init(){}
    
    let _supportedTypes = [
        "PAMMultipleSelection"
    ]
    
    public var supportedTypes: [String]! {
        return self._supportedTypes
    }
    
    open func generateStep(type: String, jsonObject: JSON, helper: RSTBTaskBuilderHelper) -> ORKStep? {
        
        guard let customStepDescriptor = helper.getCustomStepDescriptor(forJsonObject: jsonObject),
            let parameters = customStepDescriptor.parameters else {
                return nil
        }
        
        return PAMMultipleSelectionStep.create(identifier: customStepDescriptor.identifier, parameters: parameters, bundle:  Bundle(for: PAMMultipleSelectionTask.self))
    }
    
    open func processStepResult(type: String,
                                jsonObject: JsonObject,
                                result: ORKStepResult,
                                helper: RSTBTaskBuilderHelper) -> JSON? {
        return nil
    }
    
}
