//
//  CTFDelayedDiscountingRaw.swift
//  ImpulsivityOhmage
//
//  Created by James Kizer on 1/30/17.
//  Copyright © 2017 Foundry @ Cornell Tech. All rights reserved.
//

import UIKit
import sdlrkx
import ResearchSuiteResultsProcessor

final public class CTFDiscountingRaw: RSRPIntermediateResult {
    
    public var variableLabel: String!
    public var variableArray: [Double]!
    public var constantArray: [Double]!
    public var choiceArray: [Double]!
    public var times: [TimeInterval]!
    
    public init?(
        uuid: UUID,
        taskIdentifier: String,
        taskRunUUID: UUID,
        result: CTFDiscountingResult
        ) {
        
        super.init(
            type: "DiscountingRaw",
            uuid: uuid,
            taskIdentifier: taskIdentifier,
            taskRunUUID: taskRunUUID
        )
        
        self.variableLabel = result.identifier
        
        guard let trialResults = result.trialResults else {
                return nil
        }
        
        self.variableArray = trialResults.map({ (trialResult) -> Double in
            return trialResult.trial.variableAmount
        })
        
        self.constantArray = trialResults.map({ (trialResult) -> Double in
            return trialResult.trial.constantAmount
        })
        
        self.choiceArray = trialResults.map({ (trialResult) -> Double in
            return trialResult.choiceValue
        })
        
        self.times = trialResults.map({ (trialResult) -> Double in
            return trialResult.choiceTime
        })
        
    
    }

}
