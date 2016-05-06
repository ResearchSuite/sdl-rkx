//
//  RKXImageChoiceWithAdditionalText.swift
//  Pods
//
//  Created by James Kizer on 5/5/16.
//
//

import UIKit
import ResearchKit

class RKXImageChoiceWithAdditionalText: ORKImageChoice {

    var additionalText: String?
    
    required init(image: UIImage, text: String?, additionalText: String?, value: protocol<NSCoding, NSCopying, NSObjectProtocol>) {
        self.additionalText = additionalText
        super.init(normalImage: image, selectedImage: nil, text: text, value: value)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
