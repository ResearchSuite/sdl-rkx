//
//  RSEnhancedMultipleChoiceStepDescriptor.swift
//  Pods
//
//  Created by James Kizer on 4/8/17.
//
//

import Gloss
import ResearchSuiteTaskBuilder


//open class RSEnhancedMultipleChoiceStepDescriptor<ChoiceItemType: RSTBChoiceStepDescriptor.ChoiceItem>: RSTBQuestionStepDescriptor {
//    
//    public let items: [ChoiceItemType]
//    public let valueSuffix: String?
//    public let shuffleItems: Bool
//    public let maximumNumberOfItems: Int?
//    
//    public required init?(json: JSON) {
//        
//        guard let items: [ChoiceItemType] = "items" <~~ json else {
//            return nil
//        }
//        
//        self.items = items
//        self.valueSuffix = "valueSuffix" <~~ json
//        self.shuffleItems = "shuffleItems" <~~ json ?? false
//        self.maximumNumberOfItems = "maximumNumberOfItems" <~~ json
//        super.init(json: json)
//        
//    }
//    
//}
