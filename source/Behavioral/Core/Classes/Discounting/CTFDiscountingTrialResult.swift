//
//  CTFDiscountingTrialResult.swift
//  Pods
//
//  Created by James Kizer on 6/27/17.
//
//

import UIKit

public enum CTFDiscountingChoice {
    case variable
    case constant
}

public struct CTFDiscountingTrialResult {
    public let trial:CTFDiscountingTrial
    public let choiceType: CTFDiscountingChoice
    public let choiceValue: Double
    public let choiceTime: TimeInterval //time required to make choice
}
