//
//  CTFGoNoGoStepParameters.swift
//  Impulse
//
//  Created by James Kizer on 12/20/16.
//  Copyright © 2016 James Kizer. All rights reserved.
//

import UIKit

struct CTFGoNoGoStepParameters {
    
    // time vars for step
    var waitTime: TimeInterval!
    var crossTime : TimeInterval!
    var blankTime:TimeInterval!
    var cueTimeOptions: [TimeInterval]!
    var fillTime : TimeInterval!
    
    //probabilities for step
    var goCueTargetProb: Double! //refers to probability of green fill
    var noGoCueTargetProb: Double! //refers to probability of blue fill
    var goCueProb:Double! //refers probability to cue orientation
    
    //number of trials
    var numTrials:Int!
    
}
