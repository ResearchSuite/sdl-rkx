//
//  CTFBARTStep.swift
//  Impulse
//
//  Created by James Kizer on 10/17/16.
//  Copyright © 2016 James Kizer. All rights reserved.
//

import UIKit
import ResearchKit

public struct CTFBARTStepParams {
    
    //number of trials
    var numTrials:Int!
    
    var earningsPerPump: Float!
    var maxPayingPumpsPerTrial: Int!
    
    var canExplodeOnFirstPump: Bool
}

open class CTFBARTStep: ORKStep {
    
    static let identifier = "BARTStep"

    public var params:CTFBARTStepParams?
    
    open override func stepViewControllerClass() -> AnyClass {
        return CTFBARTStepViewController.self
    }
    
}
