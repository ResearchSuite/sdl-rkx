//
//  YADLFullStepDescriptor.swift
//  Pods
//
//  Created by James Kizer on 4/2/17.
//
//

import UIKit
import Gloss
import ResearchSuiteTaskBuilder

public struct YADLDifficultyChoice: Decodable {
    public let text: String
    public let value: String
    public let color: UIColor
    
    public init?(json: JSON) {
        
        guard let text: String = "text" <~~ json,
            let value: String = "value" <~~ json,
            let color: String = "color" <~~ json else {
                return nil
        }
        
        self.text = text
        self.value = value
        self.color = UIColor(hexString: color)
    
    }
}

public struct YADLItem: Decodable {
    public let identifier: String
    public let description: String
    public let imageTitle: String
    
    public init?(json: JSON) {
        guard let identifier: String = "identifier" <~~ json,
            let description: String = "description" <~~ json,
            let imageTitle: String = "imageTitle" <~~ json else {
                return nil
        }
        
        self.identifier = identifier
        self.description = description
        self.imageTitle = imageTitle
    }
}

open class YADLFullStepDescriptor: RSTBElementDescriptor {

    public let optional: Bool
    public let text: String?
    public let choices: [YADLDifficultyChoice]
    public let items: [YADLItem]
    
    required public init?(json: JSON) {
        
        guard let choices: [JSON] = "choices" <~~ json,
            let items: [JSON] = "items" <~~ json else {
                return nil
        }
        
        self.choices = choices.flatMap({YADLDifficultyChoice(json: $0)})
        self.items = items.flatMap({YADLItem(json: $0)})
        self.optional = "optional" <~~ json ?? true
        self.text = "text" <~~ json
        
        super.init(json: json)
    }
    
}
