//
//  RKSBorderedButton.swift
//  SDL-RKX
//
//  Created by James Kizer on 4/29/16.
//  Copyright © 2016 Cornell Tech Foundry. All rights reserved.
//

import UIKit

class RKXBorderedButton: UIButton {

    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
    }
    */
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.layer.borderWidth = 1.0
        self.layer.cornerRadius = 5.0
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.layer.borderWidth = 1.0
        self.layer.cornerRadius = 5.0
    }
    
    func setBorderAndTitleColor(_ color: UIColor) {
        self.setTitleColor(color, for: UIControlState())
        self.layer.borderColor = color.cgColor
    }
    var configuredColor: UIColor? {
        didSet {
            if let color = self.configuredColor {
                self.setBorderAndTitleColor(color)
            }
            else {
                self.setBorderAndTitleColor(self.tintColor)
            }
        }
    }
    
    override func tintColorDidChange() {
        //if we have not configured the color, set
        super.tintColorDidChange()
        if let _ = self.configuredColor {
            return
        }
        else {
            self.setBorderAndTitleColor(self.tintColor)
        }
    }
    
    override var intrinsicContentSize : CGSize {
        let superSize = super.intrinsicContentSize
        return CGSize(width: superSize.width + 20.0, height: superSize.height)
    }

}
