//
//  RKXMultipleImageSelectionSurveyCollectionViewCell.swift
//  sdlrkx
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
        if self.isSelected {
            self.backgroundColor = self.selectedBackgroundColor ?? self.tintColor
        }
        else {
            self.backgroundColor = UIColor.clear
        }
        
        let color = self.textStackViewBackgroundColor ?? UIColor.clear
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
            self.activityImageView.layer.borderColor = UIColor.lightGray.cgColor
            self.activityImageView.image = newActivityImage
        }
    }
    
    var selectedOverlayImage: UIImage? {
        willSet(newSelectedOverlayImage) {
            self.checkImageView.image = newSelectedOverlayImage
        }
    }
    
    override var isSelected: Bool {
        didSet {
            self.setBackgroundColor()
            self.checkImageView.isHidden = !isSelected
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
