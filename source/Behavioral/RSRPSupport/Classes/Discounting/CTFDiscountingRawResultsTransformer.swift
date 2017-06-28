//
//  CTFDelayDiscountingRawResultsTransformer.swift
//  ImpulsivityOhmage
//
//  Created by James Kizer on 1/30/17.
//  Copyright © 2017 Foundry @ Cornell Tech. All rights reserved.
//

import sdlrkx
import ResearchKit
import ResearchSuiteResultsProcessor

public class CTFDiscountingRawResultsTransformer: RSRPFrontEndTransformer {
    
    public static func transform(
        taskIdentifier: String,
        taskRunUUID: UUID,
        parameters: [String: AnyObject]
        ) -> RSRPIntermediateResult? {
        
        guard let result = parameters["result"]?.firstResult as? CTFDiscountingResult else {
            return nil
        }
        
        guard let summary = CTFDiscountingRaw(uuid: UUID(), taskIdentifier: taskIdentifier, taskRunUUID: taskRunUUID, result: result) else {
            return nil
        }
        
        summary.startDate = result.startDate
        summary.endDate = result.endDate
        
        return summary
    }
    
    private static let supportedTypes = [
        "DiscountingRaw"
    ]
    
    public static func supportsType(type: String) -> Bool {
        return self.supportedTypes.contains(type)
    }
    
}
