//
//  CTFBorderedButton.swift
//  ORKCatalog
//
//  Created by James Kizer on 9/16/16.
//  Copyright © 2016 researchkit.org. All rights reserved.
//

import UIKit

public class CTFBorderedButton: UIButton {

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
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.layer.borderWidth = 1.0
        self.layer.cornerRadius = 5.0
    }
    
    private func setTitleColor(_ color: UIColor?) {
        self.setTitleColor(color, for: UIControlState.normal)
        self.setTitleColor(UIColor.white, for: UIControlState.highlighted)
        self.setTitleColor(UIColor.white, for: UIControlState.selected)
        self.setTitleColor(UIColor.black.withAlphaComponent(0.3), for: UIControlState.disabled)
    }
    
    var configuredColor: UIColor? {
        didSet {
            if let color = self.configuredColor {
                self.setTitleColor(color)
            }
            else {
                self.setTitleColor(self.tintColor)
            }
        }
    }
    
    override public func layoutSubviews() {
        super.layoutSubviews()
        if let color = self.titleColor(for: self.state) {
            self.layer.borderColor = color.cgColor
        }
        
        
    }
    
    override public func tintColorDidChange() {
        //if we have not configured the color, set
        super.tintColorDidChange()
        if let _ = self.configuredColor {
            return
        }
        else {
            self.setTitleColor(self.tintColor)
        }
    }
    
    override public var intrinsicContentSize : CGSize {
        let superSize = super.intrinsicContentSize
        return CGSize(width: superSize.width + 20.0, height: superSize.height)
    }

}
