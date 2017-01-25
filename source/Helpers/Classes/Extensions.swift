//
//  Extensions.swift
//  Pods
//
//  Created by James Kizer on 1/9/17.
//
//

import Foundation

//extension Array {
//    
//    func random() -> Element? {
//        if self.count == 0 {
//            return nil
//        }
//        else{
//            let index = Int(arc4random_uniform(UInt32(self.count)))
//            print(index)
//            return self[index]
//        }
//    }
//}
//
//
//extension MutableCollection where Indices.Iterator.Element == Index {
//    /// Shuffles the contents of this collection.
//    mutating func shuffle() {
//        let c = count
//        guard c > 1 else { return }
//        
//        for (unshuffledCount, firstUnshuffled) in zip(stride(from: c, to: 1, by: -1), indices) {
//            let d: IndexDistance = numericCast(arc4random_uniform(numericCast(unshuffledCount)))
//            guard d != 0 else { continue }
//            let i = index(firstUnshuffled, offsetBy: d)
//            swap(&self[firstUnshuffled], &self[i])
//        }
//    }
//    
//    func shuffled() -> [Iterator.Element] {
//        var result = Array(self)
//        result.shuffle()
//        return result
//    }
//    
//    func shuffled(shouldShuffle: Bool) -> [Iterator.Element] {
//        if shouldShuffle {
//            var result = Array(self)
//            result.shuffle()
//            return result
//        }
//        else {
//            return Array(self)
//        }
//        
//    }
//}
