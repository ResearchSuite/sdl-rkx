//
//  CTFDelayDiscountingTrialResult.swift
//  Pods
//
//  Created by James Kizer on 1/30/17.
//
//

import UIKit

public enum CTFDelayDiscountingChoice{
    case Now
    case Later
}

public struct CTFDelayDiscountingTrialResult{
    public var trial:CTFDelayDiscountingTrial!
    public var choiceType: CTFDelayDiscountingChoice!
    public var choiceValue: Double!
    public var choiceTime: TimeInterval! //time required to make choice
}
