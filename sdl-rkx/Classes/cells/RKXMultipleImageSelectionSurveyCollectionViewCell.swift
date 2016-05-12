//
//  RKXMultipleImageSelectionSurveyCollectionViewCell.swift
//  sdl-rkx
//
//  Created by James Kizer on 4/5/16.
//  Copyright © 2016 Cornell Tech Foundry. All rights reserved.
//

import UIKit

class RKXMultipleImageSelectionSurveyCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var activityImageView: UIImageView!
    @IBOutlet weak var checkImageView: UIImageView!
    @IBOutlet weak var textStackView: UIStackView!
    @IBOutlet weak var primaryTextLabel: UILabel!
    @IBOutlet weak var secondaryTextLabel: UILabel!
    
    func setBackgroundColor() {
        if self.selected {
            self.backgroundColor = self.selectedBackgroundColor ?? self.tintColor
        }
        else {
            self.backgroundColor = UIColor.clearColor()
        }
        
        let color = self.textStackViewBackgroundColor ?? UIColor.clearColor()
        self.textStackView.backgroundColor = color
        self.primaryTextLabel.backgroundColor = color
        self.secondaryTextLabel.backgroundColor = color
    }
    
    var selectedBackgroundColor: UIColor? {
        didSet {
            setBackgroundColor()
        }
    }
    
    var textStackViewBackgroundColor: UIColor? {
        didSet {
            setBackgroundColor()
        }
    }
    
    override func tintColorDidChange() {
        //if we have not configured the color, set
        super.tintColorDidChange()
        setBackgroundColor()
    }
    
    
    var activityImage: UIImage? {
        willSet(newActivityImage) {
            self.activityImageView.layer.borderWidth = 1
            self.activityImageView.layer.borderColor = UIColor.lightGrayColor().CGColor
            self.activityImageView.image = newActivityImage
        }
    }
    
    var selectedOverlayImage: UIImage? {
        willSet(newSelectedOverlayImage) {
            self.checkImageView.image = newSelectedOverlayImage
        }
    }
    
    override var selected: Bool {
        didSet {
            self.setBackgroundColor()
            self.checkImageView.hidden = !selected
        }
    }
    
    var primaryText: String? {
        willSet(newPrimaryText) {
            self.primaryTextLabel.text = newPrimaryText
        }
    }
    
    var secondaryText: String? {
        willSet(newSecondaryText) {
            self.secondaryTextLabel.text = newSecondaryText
        }
    }
}
