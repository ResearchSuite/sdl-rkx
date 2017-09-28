//
//  CTFGoNoGoStepParamsDescriptor.swift
//  Impulse
//
//  Created by James Kizer on 12/20/16.
//  Copyright © 2016 James Kizer. All rights reserved.
//

import UIKit
import Gloss

class CTFGoNoGoStepParamsDescriptor: Gloss.Decodable {
    
    // time vars for step
    let waitTime: TimeInterval
    let crossTime : TimeInterval
    let blankTime:TimeInterval
    let cueTimeOptions: [TimeInterval]
    let fillTime : TimeInterval
    
    //probabilities for step
    let goCueTargetProb: Double //refers to probability of green fill
    let noGoCueTargetProb: Double //refers to probability of blue fill
    let goCueProb:Double //refers probability to cue orientation
    
    //number of trials
    let numTrials:Int
    
    required public init?(json: JSON) {
        
        guard let waitTime: TimeInterval = "waitTime" <~~ json,
            let crossTime: TimeInterval = "crossTime" <~~ json,
            let blankTime: TimeInterval = "blankTime" <~~ json,
            let cueTimeOptions: [TimeInterval] = "cueTimes" <~~ json,
            let fillTime: TimeInterval = "fillTime" <~~ json,
            let goCueTargetProb: Double = "goCueTargetProbability" <~~ json,
            let noGoCueTargetProb: Double = "noGoCueTargetProbability" <~~ json,
            let goCueProb: Double = "goCueProbability" <~~ json,
            let numTrials: Int = "numberOfTrials" <~~ json  else {
            return nil
        }
        
        self.waitTime = waitTime
        self.crossTime = crossTime
        self.blankTime = blankTime
        self.cueTimeOptions = cueTimeOptions
        self.fillTime = fillTime
        self.goCueTargetProb = goCueTargetProb
        self.noGoCueTargetProb = noGoCueTargetProb
        self.goCueProb = goCueProb
        self.numTrials = numTrials
        
        
    }

}
