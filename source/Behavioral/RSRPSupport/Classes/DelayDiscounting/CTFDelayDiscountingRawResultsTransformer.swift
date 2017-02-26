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

public class CTFDelayDiscountingRawResultsTransformer: RSRPFrontEndTransformer {
    
    public static func transform(
        taskIdentifier: String,
        taskRunUUID: UUID,
        parameters: [String: AnyObject]
        ) -> RSRPIntermediateResult? {
        
        guard let ddResult = parameters["DelayDiscountingResult"]?.firstResult as? CTFDelayDiscountingResult else {
            return nil
        }
        
        guard let summary = CTFDelayDiscountingRaw(uuid: UUID(), taskIdentifier: taskIdentifier, taskRunUUID: taskRunUUID, result: ddResult) else {
            return nil
        }
        
        summary.startDate = ddResult.startDate
        summary.endDate = ddResult.endDate
        
        return summary
    }
    
    private static let supportedTypes = [
        "DelayDiscountingRaw"
    ]
    
    public static func supportsType(type: String) -> Bool {
        return self.supportedTypes.contains(type)
    }
    
}
