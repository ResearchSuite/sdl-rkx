//
//  CTFDiscountingResult.swift
//
//  Created by James Kizer on 6/27/17.
//  Copyright © 2017 Cornell Tech. All rights reserved.
//

import ResearchKit

public class CTFDiscountingResult: ORKResult {
    
    public var trialResults: [CTFDiscountingTrialResult]?
    
    override open func copy(with zone: NSZone? = nil) -> Any {
        let theCopy = super.copy(with: zone) as! CTFDiscountingResult
        theCopy.trialResults = self.trialResults
        return theCopy
    }

}
