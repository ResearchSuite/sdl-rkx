//
//  CTFDiscountingParamsDescriptor.swift
//  Impulse
//
//  Created by James Kizer on 6/27/17.
//  Copyright © 2016 Cornell Tech. All rights reserved.
//

import UIKit
import ResearchSuiteTaskBuilder
import Gloss

open class CTFDiscountingDescriptor: RSTBStepDescriptor {
    
    let constantAmount: Double
    let initialVariableAmount: Double
    let numQuestions: Int
    let constantFormatString: String
    let variableFormatString: String
    
    required public init?(json: JSON) {
        
        guard let constantAmount: Double = "constantAmount" <~~ json,
            let initialVariableAmount: Double = "initialVariableAmount" <~~ json,
            let numQuestions: Int = "numQuestions" <~~ json,
            let constantFormatString: String = "constantFormatString" <~~ json,
            let variableFormatString: String = "variableFormatString" <~~ json else {
                return nil
        }
        
        self.constantAmount = constantAmount
        self.initialVariableAmount = initialVariableAmount
        self.numQuestions = numQuestions
        self.constantFormatString = constantFormatString
        self.variableFormatString = variableFormatString
        
        super.init(json: json)

    }
}
