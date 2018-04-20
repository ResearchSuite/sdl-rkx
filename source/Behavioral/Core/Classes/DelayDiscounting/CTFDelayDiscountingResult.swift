//
//  CTFDelayDiscountingResult.swift
//  Impulse
//
//  Created by James Kizer on 1/26/17.
//  Copyright © 2017 James Kizer. All rights reserved.
//

import ResearchKit

open class CTFDelayDiscountingResult: ORKResult {
    
    public var trialResults: [CTFDelayDiscountingTrialResult]?
    
    override open func copy(with zone: NSZone? = nil) -> Any {
        let theCopy = super.copy(with: zone) as! CTFDelayDiscountingResult
        theCopy.trialResults = self.trialResults
        return theCopy
    }

}
