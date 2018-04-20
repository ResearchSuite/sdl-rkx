//
//  CTFBARTResult.swift
//  Pods
//
//  Created by James Kizer on 1/30/17.
//
//

import ResearchKit

public class CTFBARTResult: ORKResult {
    public var trialResults: [CTFBARTTrialResult]?
    
    override open func copy(with zone: NSZone? = nil) -> Any {
        let theCopy = super.copy(with: zone) as! CTFBARTResult
        theCopy.trialResults = self.trialResults
        return theCopy
    }
    
}
