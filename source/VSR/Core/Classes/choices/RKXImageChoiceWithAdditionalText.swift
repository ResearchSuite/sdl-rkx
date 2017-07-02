//
//  RKXImageChoiceWithAdditionalText.swift
//  sdlrkx
//
//  Created by James Kizer on 5/5/16.
//  Copyright © 2016 Cornell Tech Foundry. All rights reserved.
//

import UIKit
import ResearchKit

public class RKXImageChoiceWithAdditionalText: ORKImageChoice {

    var additionalText: String?
    
    required public init(image: UIImage, text: String?, additionalText: String?, value: NSCoding & NSCopying & NSObjectProtocol) {
        self.additionalText = additionalText
        super.init(normalImage: image, selectedImage: nil, text: text, value: value)
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
