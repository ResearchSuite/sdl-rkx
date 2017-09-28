//
//  CTFDelayDiscountingParamsDescriptor.swift
//  Impulse
//
//  Created by James Kizer on 12/20/16.
//  Copyright © 2016 Cornell Tech. All rights reserved.
//

import UIKit
import Gloss

open class CTFDelayDiscountingParamsDescriptor: Gloss.Decodable {
    
    let maxAmount: Double
    let numQuestions: Int
    let nowDescription:String
    let laterDescription:String
    let formatString: String
    let prompt: String
    
    required public init?(json: JSON) {
        
        guard let maxAmount: Double = "maxAmount" <~~ json,
            let numQuestions: Int = "numQuestions" <~~ json,
            let nowDescription: String = "nowDescription" <~~ json,
            let laterDescription: String = "laterDescription" <~~ json,
            let formatString: String = "formatString" <~~ json,
            let prompt: String = "prompt" <~~ json else {
                return nil
        }
        
        self.maxAmount = maxAmount
        self.numQuestions = numQuestions
        self.nowDescription = nowDescription
        self.laterDescription = laterDescription
        self.formatString = formatString
        self.prompt = prompt

    }
}
