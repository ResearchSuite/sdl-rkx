//
//  CTFGoNoGoResult.swift
//  Pods
//
//  Created by James Kizer on 1/30/17.
//
//

import ResearchKit

public class CTFGoNoGoResult: ORKResult {
    public var trialResults: [CTFGoNoGoTrialResult]?
    
    override open func copy(with zone: NSZone? = nil) -> Any {
        let theCopy = super.copy(with: zone) as! CTFGoNoGoResult
        theCopy.trialResults = self.trialResults
        return theCopy
    }
}
