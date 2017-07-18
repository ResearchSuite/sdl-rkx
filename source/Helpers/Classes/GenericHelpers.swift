//
//  GenericHelpers.swift
//  Impulse
//
//  Created by James Kizer on 10/17/16.
//  Copyright © 2016 James Kizer. All rights reserved.
//

import Foundation

//p1 = bias, p2 = (1.0-bias)
func coinFlip<T>(_ obj1: T, obj2: T, bias: Float = 0.5) -> T {
    
    //ensure bias is in range [0.0, 1.0]
    let realBias: Float = max(min(bias, 1.0), 0.0)
    let flip = Float(arc4random()) /  Float(UInt32.max)
    
    if flip < realBias {
        return obj1
    }
    else {
        return obj2
    }
}

protocol Idable {
    var id : String { get }
}

extension Sequence {
    
    func toDict<K: Hashable, V>() -> [K: V]? {
        guard let arrayOfPairs = self as? [(K, V)] else {
            return nil
        }
        
        var returnDict: Dictionary<K, V> = [:]
        
        for pair in arrayOfPairs {
            let key: K = pair.0
            let value: V = pair.1
            returnDict[key] = value
        }
        return returnDict
    }
}

extension Date {
    static func RandomDateBetween(from: Date, to: Date) -> Date? {
        let interval = to.timeIntervalSince(from)
        
        guard interval > 0.0 else {
            return nil
        }
        
        let multiplier = CGFloat(Float(arc4random()) / Float(UINT32_MAX))
        return Date(timeInterval: interval * Double(multiplier), since: from)
    }
}
