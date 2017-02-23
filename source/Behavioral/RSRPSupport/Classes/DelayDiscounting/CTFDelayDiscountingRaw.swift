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

final public class CTFDelayDiscountingRaw: RSRPIntermediateResult {
    
    public var variableLabel: String!
    public var nowArray: [Double]!
    public var laterArray: [Double]!
    public var choiceArray: [Double]!
    public var times: [TimeInterval]!
    
    public init?(
        uuid: UUID,
        taskIdentifier: String,
        taskRunUUID: UUID,
        result: CTFDelayDiscountingResult
        ) {
        
        super.init(
            type: "DelayDiscountingRaw",
            uuid: uuid,
            taskIdentifier: taskIdentifier,
            taskRunUUID: taskRunUUID
        )
        
        self.variableLabel = result.identifier
        
        guard let trialResults = result.trialResults else {
                return nil
        }
        
        self.nowArray = trialResults.map({ (trialResult) -> Double in
            return trialResult.trial.now
        })
        
        self.laterArray = trialResults.map({ (trialResult) -> Double in
            return trialResult.trial.later
        })
        
        self.choiceArray = trialResults.map({ (trialResult) -> Double in
            return trialResult.choiceValue
        })
        
        self.times = trialResults.map({ (trialResult) -> Double in
            return trialResult.choiceTime
        })
        
    
    }

}
