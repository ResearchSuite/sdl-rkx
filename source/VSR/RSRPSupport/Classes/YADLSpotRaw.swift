//
//  YADLSpotRaw.swift
//  Pods
//
//  Created by James Kizer on 4/2/17.
//
//

import UIKit
import ResearchKit
import ResearchSuiteResultsProcessor
import Gloss

open class YADLSpotRaw: RSRPIntermediateResult, RSRPFrontEndTransformer {
    static public let kType = "YADLSpotRaw"
    
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
        
        guard let stepResult = parameters["result"] as? ORKStepResult,
            let yadlSpotResult = stepResult.results?.first as? RKXMultipleImageSelectionSurveyResult,
            let selected = yadlSpotResult.selectedIdentifiers,
            let notSelected = yadlSpotResult.notSelectedIdentifiers,
            let excluded = yadlSpotResult.excludedIdentifiers else {
                return nil
        }
        
        return YADLSpotRaw(
            uuid: UUID(),
            taskIdentifier: taskIdentifier,
            taskRunUUID: taskRunUUID,
            schemaID: schemaID,
            selected: selected,
            notSelected: notSelected,
            excluded: excluded
        )
    }
    
    public let schemaID: JSON
    public let selected: [String]
    public let notSelected: [String]
    public let excluded: [String]
    
    public init?(
        uuid: UUID,
        taskIdentifier: String,
        taskRunUUID: UUID,
        schemaID: JSON,
        selected: [String],
        notSelected: [String],
        excluded: [String]
        ) {
        
        self.schemaID = schemaID
        self.selected = selected
        self.notSelected = notSelected
        self.excluded = excluded
        
        super.init(
            type: YADLSpotRaw.kType,
            uuid: uuid,
            taskIdentifier: taskIdentifier,
            taskRunUUID: taskRunUUID
        )
    }
}
