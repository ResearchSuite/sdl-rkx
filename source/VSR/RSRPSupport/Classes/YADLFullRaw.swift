//
//  YADLFullRaw.swift
//  Pods
//
//  Created by James Kizer on 4/2/17.
//
//

import UIKit
import ResearchKit
import ResearchSuiteResultsProcessor
import Gloss

open class YADLFullRaw: RSRPIntermediateResult, RSRPFrontEndTransformer {
    static public let kType = "YADLFullRaw"
    
    private static let supportedTypes = [
        kType
    ]
    
    public static func supportsType(type: String) -> Bool {
        return supportedTypes.contains(type)
    }
    
    public static func transform(
        taskIdentifier: String,
        taskRunUUID: UUID,
        parameters: [String: AnyObject]
        ) -> RSRPIntermediateResult? {
        
        
        guard let schemaID = parameters["schemaID"] as? JSON else {
                return nil
        }
        
        let results: [(String, String)] = parameters.flatMap { (pair) -> (String, String)? in
            guard let stepResult = pair.value as? ORKStepResult,
                let choiceResult = stepResult.firstResult as? ORKChoiceQuestionResult,
                let answer = choiceResult.choiceAnswers?.first as? String,
                let identifier = stepResult.identifier.components(separatedBy: ".").last else {
                    return nil
            }
            
            return (identifier, answer)
        }
        
        var resultMap: [String: String] = [:]
        results.forEach { (pair) in
            resultMap[pair.0] = pair.1
        }
        
        return YADLFullRaw(
            uuid: UUID(),
            taskIdentifier: taskIdentifier,
            taskRunUUID: taskRunUUID,
            schemaID: schemaID,
            resultMap: resultMap
        )
    }
    
    public let resultMap: [String: String]
    public let schemaID: JSON
    
    public init?(
        uuid: UUID,
        taskIdentifier: String,
        taskRunUUID: UUID,
        schemaID: JSON,
        resultMap: [String: String]
        ) {
        
        self.schemaID = schemaID
        self.resultMap = resultMap
        
        super.init(
            type: YADLFullRaw.kType,
            uuid: uuid,
            taskIdentifier: taskIdentifier,
            taskRunUUID: taskRunUUID
        )
    }
}
