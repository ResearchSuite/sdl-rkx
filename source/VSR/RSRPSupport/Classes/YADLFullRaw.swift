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

        guard let results = parameters["results"] as? [ORKStepResult] else {
            return nil
        }
        
        
        let resultPairs: [(String, String)] = results.compactMap { (stepResult) -> (String, String)? in
            
            guard let identifier = stepResult.identifier.components(separatedBy: ".").last else {
                return nil
            }
            
            if let choiceResult = stepResult.firstResult as? ORKChoiceQuestionResult {
                guard let answer = choiceResult.choiceAnswers?.first as? String else {
                    return nil
                }
                
                return (identifier, answer)
            }
            else {
                return (identifier, "skipped")
            }
            
        }

        let resultMap = Dictionary.init(uniqueKeysWithValues: resultPairs)

        return YADLFullRaw(
            uuid: UUID(),
            taskIdentifier: taskIdentifier,
            taskRunUUID: taskRunUUID,
            parameters: parameters,
            resultMap: resultMap
        )
    }
    
    public let resultMap: [String: String]
    public let parameters: [String: AnyObject]
    
    public init?(
        uuid: UUID,
        taskIdentifier: String,
        taskRunUUID: UUID,
        parameters: [String: AnyObject],
        resultMap: [String: String]
        ) {
        
        self.parameters = parameters
        self.resultMap = resultMap
        
        super.init(
            type: YADLFullRaw.kType,
            uuid: uuid,
            taskIdentifier: taskIdentifier,
            taskRunUUID: taskRunUUID
        )
    }
}
