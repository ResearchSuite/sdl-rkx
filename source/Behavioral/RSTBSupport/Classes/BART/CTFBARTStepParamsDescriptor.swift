//
//  CTFBARTStepParamsDescriptor.swift
//  Impulse
//
//  Created by James Kizer on 12/20/16.
//  Copyright © 2016 James Kizer. All rights reserved.
//

import UIKit
import Gloss

open class CTFBARTStepParamsDescriptor: Decodable {
    
    //number of trials
    let numTrials:Int
    
    let earningsPerPump: Float
    let maxPayingPumpsPerTrial: Int
    
    let canExplodeOnFirstPump: Bool
    
    required public init?(json: JSON) {
        
        guard let numTrials: Int = "numberOfTrials" <~~ json,
            let earningsPerPump: Float = "earningsPerPump" <~~ json,
            let maxPayingPumpsPerTrial: Int = "maxPayingPumpsPerTrial" <~~ json else {
                return nil
        }
        
        self.earningsPerPump = earningsPerPump
        self.maxPayingPumpsPerTrial = maxPayingPumpsPerTrial
        self.numTrials = numTrials
        self.canExplodeOnFirstPump = "canExplodeOnFirstPump" <~~ json ?? true
        
        
    }

}
