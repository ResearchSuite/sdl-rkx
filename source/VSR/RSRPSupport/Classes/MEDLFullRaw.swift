//
//  MEDLFullRaw.swift
//  Pods
//
//  Created by Christina Tsangouri on 1/10/18.
//
//


import UIKit
import ResearchKit
import ResearchSuiteResultsProcessor
import Gloss

open class MEDLFullRaw: RSRPIntermediateResult, RSRPFrontEndTransformer {
    static open let kType = "MEDLFullRaw"
    
    fileprivate static let supportedTypes = [
        kType
    ]
    
    open static func supportsType(type: String) -> Bool {
        return supportedTypes.contains(type)
    }
    
    
    
    open static func transform(
        taskIdentifier: String,
        taskRunUUID: UUID,
        parameters: [String: AnyObject]
        ) -> RSRPIntermediateResult? {
        
        
        guard let schemaID = parameters["schemaID"] as? JSON else {
            return nil
        }
        
        
        let results: [(String, [String])] = parameters.flatMap { (pair) -> (String, [String])? in
            guard let stepResult = pair.value as? ORKStepResult,
                let medlFullResult = stepResult.results?.first as? RKXMultipleImageSelectionSurveyResult,
                let selected = medlFullResult.selectedIdentifiers,
                let identifier = stepResult.identifier.components(separatedBy: ".").last else {
                    return nil
            }
            
            return (identifier,selected)
            
        }
        
        var resultMap: [String: [String]] = [:]
        
        for (identifier,selected) in results {
            resultMap[identifier] = selected
        }
    

    
        return MEDLFullRaw(
            uuid: UUID(),
            taskIdentifier: taskIdentifier,
            taskRunUUID: taskRunUUID,
            schemaID: schemaID,
            resultMap: resultMap
        )
    }
    
    open let resultMap: [String: [String]]
    open let schemaID: JSON
    
    public init?(
        uuid: UUID,
        taskIdentifier: String,
        taskRunUUID: UUID,
        schemaID: JSON,
        resultMap: [String: [String]]
        ) {
        
        self.schemaID = schemaID
        self.resultMap = resultMap
        
        super.init(
            type: MEDLFullRaw.kType,
            uuid: uuid,
            taskIdentifier: taskIdentifier,
            taskRunUUID: taskRunUUID
        )
    }
}
