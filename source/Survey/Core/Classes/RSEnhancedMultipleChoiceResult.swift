//
//  RSEnhancedMultipleChoiceResult.swift
//  Pods
//
//  Created by James Kizer on 4/10/17.
//
//

import UIKit
import ResearchKit

public struct RSEnahncedMultipleChoiceSelection {
    let value: NSCoding & NSCopying & NSObjectProtocol
    let auxiliaryResult: ORKResult?
}

open class RSEnhancedMultipleChoiceResult: ORKResult {
    
    var choiceAnswers: [RSEnahncedMultipleChoiceSelection]?
    
}
