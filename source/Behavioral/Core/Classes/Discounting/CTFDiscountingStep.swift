//
//  CTFDiscountingStep.swift
//  Impulse
//
//  Created by James Kizer on 6/27/17.
//  Copyright © 2016 Cornell Tech. All rights reserved.
//

import ResearchKit

open class CTFDiscountingStep: ORKStep {
    
    static let defaultNextAmountClosure: ([CTFDiscountingTrialResult]) -> Double? = { trialResults in
        
        //assume at least one trial result
        
        guard let outerHead = trialResults.first else {
            assertionFailure("There must be at least one trial result")
            return nil
        }
        
        let outerTail = Array(trialResults.dropFirst())
        
        //if choice is variable, next variable amount should be lower
        //if choice is constant, next variable amount should be higher
        
        func nextAmountHelper(head: CTFDiscountingTrialResult, tail: [CTFDiscountingTrialResult], absoluteDifference: Double) -> Double {
            
            //if base case (i.e., tail is empty), return the previous trial variable amount offset by the difference amount
            guard let newHead = tail.first else {
                let differenceAmount = head.choiceType == .variable ? -absoluteDifference : absoluteDifference
                return head.trial.variableAmount + differenceAmount
            }
            
            //otherwise, recurse, reducing the difference amount by half
            return nextAmountHelper(head: newHead, tail: Array(tail.dropFirst()), absoluteDifference: absoluteDifference/2.0)
            
        }
        
        
        return nextAmountHelper(head: outerHead, tail: outerTail, absoluteDifference: outerHead.trial.variableAmount / 2.0 )
        
    }

    let constantAmount: Double
    let initialVariableAmount: Double
    let computeNextVariableAmount: ([CTFDiscountingTrialResult]) -> Double?
    let numQuestions: Int
    let constantFormatString: String
    let variableFormatString: String
    
    open override func stepViewControllerClass() -> AnyClass {
        return CTFDiscountingStepViewController.self
    }
    
    public init(
        identifier: String,
        text: String,
        constantAmount: Double,
        initialVariableAmount: Double,
        computeNextVariableAmount: @escaping ([CTFDiscountingTrialResult]) -> Double? = defaultNextAmountClosure,
        numQuestions: Int,
        constantFormatString: String,
        variableFormatString: String
        ) {
        
        self.constantAmount = constantAmount
        self.initialVariableAmount = initialVariableAmount
        self.computeNextVariableAmount = computeNextVariableAmount
        self.numQuestions = numQuestions
        self.constantFormatString = constantFormatString
        self.variableFormatString = variableFormatString
        
        super.init(identifier: identifier)
        self.text = text
        
    }
    
    required public init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
