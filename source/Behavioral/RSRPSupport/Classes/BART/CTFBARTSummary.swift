//
//  CTFBARTSummary.swift
//  ImpulsivityOhmage
//
//  Created by James Kizer on 1/30/17.
//  Copyright © 2017 Foundry @ Cornell Tech. All rights reserved.
//

import sdlrkx
import ResearchSuiteResultsProcessor

public final class CTFBARTSummary: RSRPIntermediateResult {
    
    var variableLabel: String!
    var maxPumpsPerBalloon: Int!
    
    var pumpsPerBalloon: [Int]!
    
    var numberOfBalloons: Int!
    var numberOfExplosions: Int!
    
    var meanPumpsAfterExplode: Double!
    var meanPumpsAfterNoExplode: Double!
    
    var pumpsMean: Double!
    var pumpsRange: Int!
    var pumpsStdDev: Double!
    
    var firstThirdPumpsMean: Double!
    var firstThirdPumpsRange: Int!
    var firstThirdPumpsStdDev: Double!
    
    var middleThirdPumpsMean: Double!
    var middleThirdPumpsRange: Int!
    var middleThirdPumpsStdDev: Double!
    
    var lastThirdPumpsMean: Double!
    var lastThirdPumpsRange: Int!
    var lastThirdPumpsStdDev: Double!
    
    var researcherCode: String = ""
    
    var totalGains: Double!

    public init?(
        uuid: UUID,
        taskIdentifier: String,
        taskRunUUID: UUID,
        result: CTFBARTResult
        ) {
        
        super.init(
            type: "BARTSummary",
            uuid: uuid,
            taskIdentifier: taskIdentifier,
            taskRunUUID: taskRunUUID
        )
        
        guard let trialResults = result.trialResults,
            let firstResult = trialResults.first else {
            return nil
        }
        
        self.variableLabel = String(format: "BART%.02f", firstResult.trial.earningsPerPump)
        self.maxPumpsPerBalloon = firstResult.trial.maxPayingPumps
        
        self.pumpsPerBalloon = trialResults.map({ (trialResult) -> Int in
            return trialResult.numPumps
        })
        
        self.numberOfBalloons = trialResults.count
        
        let explodedIndices: Set<Int> = Set( trialResults.filter {$0.exploded}.map {$0.trial.trialIndex} )
        
        self.numberOfExplosions = explodedIndices.count
        self.totalGains = trialResults.map{ Double($0.payout) }.reduce(0.0, +)
        
        func afterExplode(trialResult: CTFBARTTrialResult) -> Bool {
            
            let index: Int = trialResult.trial.trialIndex
            
            return index != 0 && explodedIndices.contains(index-1)
            
        }
        
        let trialsAfterExplosion = trialResults.filter({return afterExplode(trialResult: $0)})
        let totalPumpsAfterExplosion: Int = trialsAfterExplosion.map({$0.numPumps}).reduce(0, +)
        
        self.meanPumpsAfterExplode = trialsAfterExplosion.count > 0 ?
            Double(totalPumpsAfterExplosion) / Double(trialsAfterExplosion.count) :
            0.0
        
        let trialsAfterNoExplosion = trialResults.filter({return !afterExplode(trialResult: $0)})
        let totalPumpsAfterNoExplosion: Int = trialsAfterNoExplosion.map({$0.numPumps}).reduce(0, +)
        
        self.meanPumpsAfterNoExplode = trialsAfterNoExplosion.count > 0 ?
            Double(totalPumpsAfterNoExplosion) / Double(trialsAfterNoExplosion.count) :
            0.0

        func summaryStatistics(trialResults: [CTFBARTTrialResult]) -> (Double, Int, Double)? {
            
            let pumpArray: [Int] = trialResults.map({$0.numPumps})
            let totalPumps = pumpArray.reduce(0, +)
            let pumpMean: Double = Double(totalPumps) / Double(pumpArray.count)
            
            
            guard let pumpMin = pumpArray.min(),
                let pumpMax = pumpArray.max() else {
                    return nil
                
            }
            
            let pumpRange = pumpMax - pumpMin
            
            let expressionValues = NSExpression(forConstantValue: pumpArray)
            let stdDevExpression = NSExpression(forFunction: "stddev:", arguments: [expressionValues])
            guard let stdDev = stdDevExpression.expressionValue(with: nil, context: nil) as? Double else {
                return nil
            }
            
            return (pumpMean, pumpRange, stdDev)
            
        }
        
        if let (mean, range, stdDev) = summaryStatistics(trialResults: trialResults) {
            self.pumpsMean = mean
            self.pumpsRange = range
            self.pumpsStdDev = stdDev
        }
        else {
            return nil
        }
        
        if let (mean, range, stdDev) = summaryStatistics(trialResults:  Array(trialResults[0..<(trialResults.count/3)]) ) {
            self.firstThirdPumpsMean = mean
            self.firstThirdPumpsRange = range
            self.firstThirdPumpsStdDev = stdDev
        }
        else {
            return nil
        }
        
        if let (mean, range, stdDev) = summaryStatistics(trialResults: Array(trialResults[(trialResults.count/3)..<2*(trialResults.count/3)])) {
            self.middleThirdPumpsMean = mean
            self.middleThirdPumpsRange = range
            self.middleThirdPumpsStdDev = stdDev
        }
        else {
            return nil
        }
        
        if let (mean, range, stdDev) = summaryStatistics(trialResults: Array(trialResults[2*(trialResults.count/3)..<trialResults.count])) {
            self.lastThirdPumpsMean = mean
            self.lastThirdPumpsRange = range
            self.lastThirdPumpsStdDev = stdDev
        }
        else {
            return nil
        }
        
    }
    
    
    //note that this a work around for the swift dictionary literal compiler bug
    public func dataDictionary() -> [String:Any] {
        
        var bodyDictionary: [String: Any] = [:]
        
        bodyDictionary["variable_label"] = self.variableLabel
        bodyDictionary["max_pumps_per_balloon"] = self.maxPumpsPerBalloon
        bodyDictionary["pumps_per_balloon"] = self.pumpsPerBalloon
        
        bodyDictionary["mean_pumps_after_explode"] = self.meanPumpsAfterExplode
        bodyDictionary["mean_pumps_after_no_explode"] = self.meanPumpsAfterNoExplode
        
        bodyDictionary["number_of_balloons"] = self.numberOfBalloons
        bodyDictionary["number_of_explosions"] = self.numberOfExplosions
        
        bodyDictionary["pumps_mean"] = self.pumpsMean
        bodyDictionary["pumps_mean_first_third"] = self.firstThirdPumpsMean
        bodyDictionary["pumps_mean_second_third"] = self.middleThirdPumpsMean
        bodyDictionary["pumps_mean_last_third"] = self.lastThirdPumpsMean
        
        bodyDictionary["pumps_range"] = self.pumpsRange
        bodyDictionary["pumps_range_first_third"] = self.firstThirdPumpsRange
        bodyDictionary["pumps_range_second_third"] = self.middleThirdPumpsRange
        bodyDictionary["pumps_range_last_third"] = self.lastThirdPumpsRange
        
        bodyDictionary["pumps_standard_deviation"] = self.pumpsStdDev
        bodyDictionary["pumps_standard_deviation_first_third"] = self.firstThirdPumpsRange
        bodyDictionary["pumps_standard_deviation_second_third"] = self.middleThirdPumpsStdDev
        bodyDictionary["pumps_standard_deviation_last_third"] = self.lastThirdPumpsStdDev
        
        bodyDictionary["researcher_code"] = self.researcherCode
        bodyDictionary["total_gains"] = self.totalGains
        
        return bodyDictionary
    }

}
