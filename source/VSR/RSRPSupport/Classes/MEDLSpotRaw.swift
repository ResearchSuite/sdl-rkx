//
//  MEDLSpotRaw.swift
//  Pods
//
//  Created by Christina Tsangouri on 1/10/18.
//
//

import UIKit
import ResearchKit
import ResearchSuiteResultsProcessor
import Gloss

open class MEDLSpotRaw: RSRPIntermediateResult, RSRPFrontEndTransformer {
    static open let kType = "MEDLSpotRaw"
    
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
        
        guard let stepResult = parameters["result"] as? ORKStepResult,
            let medlSpotResult = stepResult.results?.first as? RKXMultipleImageSelectionSurveyResult,
            let selected = medlSpotResult.selectedIdentifiers,
            let notSelected = medlSpotResult.notSelectedIdentifiers,
            let excluded = medlSpotResult.excludedIdentifiers else {
                return nil
        }
        
        return MEDLSpotRaw(
            uuid: UUID(),
            taskIdentifier: taskIdentifier,
            taskRunUUID: taskRunUUID,
            schemaID: schemaID,
            selected: selected,
            notSelected: notSelected,
            excluded: excluded
        )
    }
    
    open let schemaID: JSON
    open let selected: [String]
    open let notSelected: [String]
    open let excluded: [String]
    
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
            type: MEDLSpotRaw.kType,
            uuid: uuid,
            taskIdentifier: taskIdentifier,
            taskRunUUID: taskRunUUID
        )
    }
}
