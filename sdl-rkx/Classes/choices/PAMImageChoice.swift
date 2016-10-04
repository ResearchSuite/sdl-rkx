//
//  PAMImageChoice.swift
//  sdl-rkx
//
//  Created by James Kizer on 5/3/16.
//  Copyright © 2016 Cornell Tech Foundry. All rights reserved.
//

import UIKit
import ResearchKit

class PAMImageChoice: ORKImageChoice {

    let images: [UIImage]
    required init(images: [UIImage], value: NSCoding & NSCopying & NSObjectProtocol) {
        self.images = images
        super.init(normalImage: nil, selectedImage: nil, text: nil, value: value)
    }
    
    override var normalStateImage: UIImage {
        let numberOfImages:UInt32 = UInt32(self.images.count)
        let index = Int(arc4random_uniform(numberOfImages))
        return self.images[index]
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
