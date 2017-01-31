//
//  CTFGoNoGoTrial.swift
//  Pods
//
//  Created by James Kizer on 1/30/17.
//
//

import UIKit

public enum CTFGoNoGoCueType {
    case go
    case noGo
}

public enum CTFGoNoGoTargetType {
    case go
    case noGo
}

public struct CTFGoNoGoTrial {
    
    public var waitTime: TimeInterval!
    public var crossTime : TimeInterval!
    public var blankTime:TimeInterval!
    public var cueTime: TimeInterval!
    public var fillTime : TimeInterval!
    
    public var cue: CTFGoNoGoCueType!
    public var target: CTFGoNoGoTargetType!
    
    public var trialIndex: Int!
    
}
