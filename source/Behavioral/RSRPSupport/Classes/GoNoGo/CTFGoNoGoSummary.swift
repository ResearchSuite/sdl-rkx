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

public struct CTFGoNoGoStreakStruct {
    let count: Int
    let correct: Bool
}

public struct CTFGoNoGoSummaryStruct {
    public var numberOfTrials: Int
    public var numberOfCorrectResponses: Int
    public var numberOfCorrectNonresponses: Int
    public var numberOfIncorrectResponses: Int
    public var numberOfIncorrectNonresponses: Int
    public var meanAccuracy: Double
    public var responseTimeMean: TimeInterval
    public var responseTimeRange: TimeInterval
    public var responseTimeStdDev: TimeInterval
    //punt on these for now
    public var meanResponseTimeAfterOneIncorrect: TimeInterval
    public var meanResponseTimeAfterTenCorrect: TimeInterval
    public var meanResponseTimeCorrect: TimeInterval
    public var meanResponseTimeIncorrect: TimeInterval
    
    public func toDict() -> [String: Any] {
        return [
            "numberOfTrials": self.numberOfTrials,
            "numberOfCorrectResponses": self.numberOfCorrectResponses,
            "numberOfCorrectNonresponses": self.numberOfCorrectNonresponses,
            "numberOfIncorrectResponses": self.numberOfIncorrectResponses,
            "numberOfIncorrectNonresponses": self.numberOfIncorrectNonresponses,
            "meanAccuracy": self.meanAccuracy,
            "responseTimeMean": self.responseTimeMean,
            "responseTimeRange": self.responseTimeRange,
            "responseTimeStdDev": self.responseTimeStdDev,
            "meanResponseTimeAfterOneIncorrect": self.meanResponseTimeAfterOneIncorrect,
            "meanResponseTimeAfterTenCorrect": self.meanResponseTimeAfterTenCorrect,
            "meanResponseTimeCorrect": self.meanResponseTimeCorrect,
            "meanResponseTimeIncorrect": self.meanResponseTimeIncorrect
        ]
    }
}

public final class CTFGoNoGoSummary: RSRPIntermediateResult {
    
    public var variableLabel: String!
    public var numberOfTrials: Int!
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
        
        
        self.variableLabel = result.identifier
        self.numberOfTrials = totalTrials.count
        
        //this should evaluate to correctness
        func correct(trialResult: CTFGoNoGoTrialResult) -> Bool {
            return trialResult.tapped == (trialResult.trial.target == .go)
        }
        
        //TODO: Streaks seem to be off by one
        let streaks: [CTFGoNoGoStreakStruct] = totalTrials.reduce([]) { (acc, trialResult) -> [CTFGoNoGoStreakStruct] in
            
            if let last = acc.last {
                let newStreak: CTFGoNoGoStreakStruct = {
                    if correct(trialResult: trialResult) == last.correct {
                        return CTFGoNoGoStreakStruct(count: last.count + 1, correct: last.correct)
                    }
                    else {
                        return CTFGoNoGoStreakStruct(count: 1, correct: !last.correct)
                    }
                }()
                
                return acc + [newStreak]
                
            }
            else {
                return [CTFGoNoGoStreakStruct(count: 0, correct: correct(trialResult: trialResult))]
            }
            
        }
        
        assert(streaks.count == totalTrials.count, "Streaks and Trials not the same length")
    
        self.totalSummary = CTFGoNoGoSummary.generateSummary(trialResults: totalTrials, streaks: streaks)
        
        let firstTrials = Array(totalTrials[(0..<(totalTrials.count/3))])
        let firstStreaks = Array(streaks[(0..<(totalTrials.count/3))])
        self.firstThirdSummary = CTFGoNoGoSummary.generateSummary(trialResults: firstTrials, streaks: firstStreaks)

        let middleTrials = Array(totalTrials[((totalTrials.count/3)..<2*(totalTrials.count/3))])
        let middleStreaks = Array(streaks[((totalTrials.count/3)..<2*(totalTrials.count/3))])
        self.middleThirdSummary = CTFGoNoGoSummary.generateSummary(trialResults: middleTrials, streaks: middleStreaks)
        
        let lastTrials = Array(totalTrials[(2*(totalTrials.count/3)..<totalTrials.count)])
        let lastStreaks = Array(streaks[(2*(totalTrials.count/3)..<totalTrials.count)])
        self.lastThirdSummary = CTFGoNoGoSummary.generateSummary(trialResults: lastTrials, streaks: lastStreaks)
        
        
    }
    
    static func generateSummary(trialResults: [CTFGoNoGoTrialResult], streaks: [CTFGoNoGoStreakStruct]) -> CTFGoNoGoSummaryStruct? {
        
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
        
        let responseTimeRange = responseTimeMax - responseTimeMin
        
        let responseTimeStdDev: TimeInterval = {
            
            if responseTimes.count > 0 {
                let expressionValues = NSExpression(forConstantValue: responseTimes)
                let stdDevExpression = NSExpression(forFunction: "stddev:", arguments: [expressionValues])
                guard let stdDev = stdDevExpression.expressionValue(with: nil, context: nil) as? Double else {
                    return 0.0
                }
                return stdDev
            }
            else {
                return 0.0
            }
            
        }()
        
        let meanResponseTimeCorrect: TimeInterval = correctResponses.count > 0 ? correctResponses.map({$0.responseTime}).reduce(0.0, +) / Double(correctResponses.count) : 0.0
        
        let meanResponseTimeIncorrect: TimeInterval = incorrectResponses.count > 0 ? incorrectResponses.map({$0.responseTime}).reduce(0.0, +) / Double(incorrectResponses.count) : 0.0
        
        //avg response time after one error
        //zip, filter, map
        let resultsAfterOneIncorrect = zip(trialResults, streaks).filter { (result, streak) -> Bool in
            return streak.count == 1 && !streak.correct
        }.map { (result, streak) -> CTFGoNoGoTrialResult in
            return result
        }
        
        let meanResponseTimeAfterOneIncorrect: TimeInterval = resultsAfterOneIncorrect.count > 0 ? resultsAfterOneIncorrect.map({$0.responseTime}).reduce(0.0, +) / Double(resultsAfterOneIncorrect.count) : 0.0
        
        let resultsAfter10Correct = zip(trialResults, streaks).filter { (result, streak) -> Bool in
            return streak.count == 10 && streak.correct
            }.map { (result, streak) -> CTFGoNoGoTrialResult in
                return result
        }
        
        let meanResponseTimeAfterTenCorrect: TimeInterval = resultsAfter10Correct.count > 0 ? resultsAfter10Correct.map({$0.responseTime}).reduce(0.0, +) / Double(resultsAfter10Correct.count) : 0.0
        
        return CTFGoNoGoSummaryStruct(
            numberOfTrials: numberOfTrials,
            numberOfCorrectResponses: numberOfCorrectResponses,
            numberOfCorrectNonresponses: numberOfCorrectNonresponses,
            numberOfIncorrectResponses: numberOfIncorrectResponses,
            numberOfIncorrectNonresponses: numberOfIncorrectNonresponses,
            meanAccuracy: meanAccuracy,
            responseTimeMean: meanResponseTime,
            responseTimeRange: responseTimeRange,
            responseTimeStdDev: responseTimeStdDev,
            meanResponseTimeAfterOneIncorrect: meanResponseTimeAfterOneIncorrect,
            meanResponseTimeAfterTenCorrect: meanResponseTimeAfterTenCorrect,
            meanResponseTimeCorrect: meanResponseTimeCorrect,
            meanResponseTimeIncorrect: meanResponseTimeIncorrect)
        
    }
    

}
