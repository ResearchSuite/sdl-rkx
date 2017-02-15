//
//  PAMImageChoice.swift
//  sdlrkx
//
//  Created by James Kizer on 5/3/16.
//  Copyright © 2016 Cornell Tech Foundry. All rights reserved.
//

import UIKit
import ResearchKit

class PAMImageChoice: ORKImageChoice {

    let images: [(String, UIImage)]
    var _currentImageName: String?
    
    required init(images: [(String, UIImage)], value: NSCoding & NSCopying & NSObjectProtocol) {
        self.images = images
        super.init(normalImage: nil, selectedImage: nil, text: nil, value: value)
    }
    
    var currentImageName: String? {
        return _currentImageName
    }
    
    override var normalStateImage: UIImage {
        let numberOfImages:UInt32 = UInt32(self.images.count)
        let index = Int(arc4random_uniform(numberOfImages))
        let (imageName, image) = self.images[index]
        self._currentImageName = imageName
        return image
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
