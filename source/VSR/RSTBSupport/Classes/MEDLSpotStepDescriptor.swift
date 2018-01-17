//
//  MEDLSpotStepDescriptor.swift
//  PAM-Reference-App
//
//  Created by Christina Tsangouri on 1/3/18.
//  Copyright © 2018 Christina Tsangouri. All rights reserved.
//

import UIKit
import Gloss
import ResearchSuiteTaskBuilder

open class MEDLSpotDescriptor: RSTBStepDescriptor {
    
    open let filterKey: String?
    open let items: [MEDLItem]
    
    required public init?(json: JSON) {
        
        guard let items: [JSON] = "items" <~~ json else {
            return nil
        }
        
        self.items = items.flatMap({MEDLItem(json: $0)})
        self.filterKey = "filterKey" <~~ json
        
        super.init(json: json)
    }
    
}

