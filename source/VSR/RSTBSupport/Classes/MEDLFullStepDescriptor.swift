//
//  MEDLFullStepDescriptor.swift
//  PAM-Reference-App
//
//  Created by Christina Tsangouri on 12/22/17.
//  Copyright © 2017 Christina Tsangouri. All rights reserved.
//

import UIKit
import Gloss
import ResearchSuiteTaskBuilder

public struct MEDLItem: Gloss.Decodable {
    public let identifier: String
    public let generalDescription: String
    public let specificDescription: String
    public let imageTitle: String
    public let category: String
    
    public init?(json: JSON) {
        guard let identifier: String = "identifier" <~~ json,
            let generalDescription: String = "generalDescription" <~~ json,
            let specificDescription: String = "specificDescription" <~~ json,
            let category: String = "category" <~~ json,
            let imageTitle: String = "imageTitle" <~~ json else {
                return nil
        }
        
        self.identifier = identifier
        self.generalDescription = generalDescription
        self.specificDescription = specificDescription
        self.category = category
        self.imageTitle = imageTitle
    }
}


open class MEDLFullStepDescriptor: RSTBElementDescriptor {
    
    open let optional: Bool
    open let text: String?
    open let items: [MEDLItem]
    
    
    required public init?(json: JSON) {
        
        guard let items: [JSON] = "items" <~~ json else {
            return nil
        }
        
        self.items = items.flatMap({MEDLItem(json: $0)})
        self.optional = "optional" <~~ json ?? true
        self.text = "text" <~~ json
        
        
        super.init(json: json)
    }
    
}
