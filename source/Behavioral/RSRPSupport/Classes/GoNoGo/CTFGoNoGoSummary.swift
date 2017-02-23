//
//  CTFGoNoGoSummary.swift
//  ImpulsivityOhmage
//
//  Created by James Kizer on 1/29/17.
//  Copyright © 2017 Foundry @ Cornell Tech. All rights reserved.
//

import UIKit
import sdlrkx
import ResearchSuiteResultsProcessor

public struct CTFGoNoGoSummaryStruct {
    var numberOfTrials: Int
    var numberOfCorrectResponses: Int
    var numberOfCorrectNonresponses: Int
    var numberOfIncorrectResponses: Int
    var numberOfIncorrectNonresponses: Int
    var meanAccuracy: Double
    var responseTimeMean: TimeInterval
    var responseTimeMin: TimeInterval
    var responseTimeMax: TimeInterval
    //punt on these for now
    //var meanResponseTimeAfterOneError: TimeInterval
    //var meanResponseTimeAfterTenStreak: TimeInterval
    var meanResponseTimeCorrect: TimeInterval
    var meanResponseTimeIncorrect: TimeInterval
    
    public func toDict() -> [String: Any] {
        return [
            "numberOfTrials": self.numberOfTrials,
            "numberOfCorrectResponses": self.numberOfCorrectResponses,
            "numberOfCorrectNonresponses": self.numberOfCorrectNonresponses,
            "numberOfIncorrectResponses": self.numberOfIncorrectResponses,
            "numberOfIncorrectNonresponses": self.numberOfIncorrectNonresponses,
            "meanAccuracy": self.meanAccuracy,
            "responseTimeMean": self.responseTimeMean,
            "responseTimeMin": self.responseTimeMin,
            "responseTimeMax": self.responseTimeMax,
            "meanResponseTimeCorrect": self.meanResponseTimeCorrect,
            "meanResponseTimeIncorrect": self.meanResponseTimeIncorrect
        ]
    }
}

public final class CTFGoNoGoSummary: RSRPIntermediateResult {
    
    public var totalSummary: CTFGoNoGoSummaryStruct!
    public var firstThirdSummary: CTFGoNoGoSummaryStruct!
    public var middleThirdSummary: CTFGoNoGoSummaryStruct!
    public var lastThirdSummary: CTFGoNoGoSummaryStruct!
    
    public init?(
        uuid: UUID,
        taskIdentifier: String,
        taskRunUUID: UUID,
        result: CTFGoNoGoResult
        ) {
        
        super.init(
            type: "GoNoGoSummary",
            uuid: uuid,
            taskIdentifier: taskIdentifier,
            taskRunUUID: taskRunUUID
        )
        
        guard let totalTrials = result.trialResults else {
            return nil
        }
        
        self.totalSummary = CTFGoNoGoSummary.generateSummary(trialResults: totalTrials)
        
        let firstTrials = Array(totalTrials[(0..<(totalTrials.count/3))])
        self.firstThirdSummary = CTFGoNoGoSummary.generateSummary(trialResults: firstTrials)

        let middleTrials = Array(totalTrials[((totalTrials.count/3)..<2*(totalTrials.count/3))])
        self.middleThirdSummary = CTFGoNoGoSummary.generateSummary(trialResults: middleTrials)
        
        let lastTrials = Array(totalTrials[(2*(totalTrials.count/3)..<totalTrials.count)])
        self.lastThirdSummary = CTFGoNoGoSummary.generateSummary(trialResults: lastTrials)
        
        
    }
    
    static func generateSummary(trialResults: [CTFGoNoGoTrialResult]) -> CTFGoNoGoSummaryStruct? {
        
        guard trialResults.count > 0 else {
            return nil
        }
        
        let correctResponses = trialResults.filter { (result) -> Bool in
            return result.trial.target == .go && result.tapped
        }
        
        let correctNonresponses = trialResults.filter { (result) -> Bool in
            return result.trial.target == .noGo && !result.tapped
        }
        
        let incorrectResponses = trialResults.filter { (result) -> Bool in
            return result.trial.target == .noGo && result.tapped
        }
        
        let incorrectNonresponses = trialResults.filter { (result) -> Bool in
            return result.trial.target == .go && !result.tapped
        }
        
        
        let numberOfTrials = trialResults.count
        let numberOfCorrectResponses = correctResponses.count
        let numberOfCorrectNonresponses = correctNonresponses.count
        let numberOfIncorrectResponses = incorrectResponses.count
        let numberOfIncorrectNonresponses = incorrectNonresponses.count
        
        let meanAccuracy = (Double(numberOfCorrectResponses) + Double(numberOfCorrectNonresponses)) / Double(numberOfTrials)
        
        let responseTimes: [TimeInterval] = correctResponses.map({$0.responseTime}) + incorrectResponses.map({$0.responseTime})

        let meanResponseTime: TimeInterval = responseTimes.count > 0 ? responseTimes.reduce(0.0, +) / Double(responseTimes.count) : 0.0
        
        let responseTimeMin: TimeInterval = responseTimes.min() ?? 0.0
        let responseTimeMax: TimeInterval = responseTimes.max() ?? 0.0
        
        let meanResponseTimeCorrect: TimeInterval = correctResponses.count > 0 ? correctResponses.map({$0.responseTime}).reduce(0.0, +) / Double(correctResponses.count) : 0.0
        
        let meanResponseTimeIncorrect: TimeInterval = correctResponses.count > 0 ? incorrectResponses.map({$0.responseTime}).reduce(0.0, +) / Double(incorrectResponses.count) : 0.0
        
        
        return CTFGoNoGoSummaryStruct(
            numberOfTrials: numberOfTrials,
            numberOfCorrectResponses: numberOfCorrectResponses,
            numberOfCorrectNonresponses: numberOfCorrectNonresponses,
            numberOfIncorrectResponses: numberOfIncorrectResponses,
            numberOfIncorrectNonresponses: numberOfIncorrectNonresponses,
            meanAccuracy: meanAccuracy,
            responseTimeMean: meanResponseTime,
            responseTimeMin: responseTimeMin,
            responseTimeMax: responseTimeMax,
            meanResponseTimeCorrect: meanResponseTimeCorrect,
            meanResponseTimeIncorrect: meanResponseTimeIncorrect)
        
    }
    

}
