//
//  YADLSpotAssessmentCollectionViewCell.swift
//  YADL
//
//  Created by James Kizer on 4/5/16.
//  Copyright © 2016 Cornell Tech Foundry. All rights reserved.
//

import UIKit

class RKXMultipleImageSelectionSurveyCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var activityImageView: UIImageView!
    @IBOutlet weak var checkImageView: UIImageView!
    
    func setBackgroundColor() {
        if self.selected {
            if let color = self.selectedBackgroundColor {
                self.backgroundColor = color
            }
            else {
                self.backgroundColor = self.tintColor
            }
        }
        else {
            self.backgroundColor = UIColor.clearColor()
        }
    }
    
    var selectedBackgroundColor: UIColor? {
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
    
}
