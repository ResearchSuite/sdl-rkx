//
//  CTFDelayDiscountingStep.swift
//  Impulse
//
//  Created by Francesco Perera on 10/25/16.
//  Copyright © 2016 Cornell Tech. All rights reserved.
//

import ResearchKit


struct CTFDelayDiscountingStepParams {
    var maxAmount: Double!
    var numQuestions: Int!
    var nowDescription:String!
    var laterDescription:String!
    var formatString: String!
    var prompt: String!
}

open class CTFDelayDiscountingStep: ORKStep {
    
    static let identifier = "DelayDiscountingStep"
    
    var params:CTFDelayDiscountingStepParams?
    
    open override func stepViewControllerClass() -> AnyClass {
        return CTFDelayDiscountingStepViewController.self
    }
    
}
