//
//  RSQuestionViewController.swift
//  Pods
//
//  Created by James Kizer on 4/16/17.
//
//

import UIKit
import ResearchKit

open class RSQuestionViewController: ORKStepViewController {
    
    static let footerHeightWithoutContinueButton: CGFloat = 61.0
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var textLabel: UILabel!
    @IBOutlet public weak var contentView: UIView!
    @IBOutlet weak var continueButton: CTFBorderedButton!
    @IBOutlet weak var skipButton: UIButton!
    @IBOutlet weak var footerHeight: NSLayoutConstraint!
    
    open var skipped: Bool = false
    
    open class var showsContinueButton: Bool {
        return true
    }

    override convenience init(step: ORKStep?) {
        self.init(step: step, result: nil)
    }
    
    override convenience init(step: ORKStep?, result: ORKResult?) {
        
        let framework = Bundle(for: RSQuestionViewController.self)
        self.init(nibName: "RSQuestionViewController", bundle: framework)
        self.step = step
        self.restorationIdentifier = step!.identifier
        
    }
    
    override open func viewDidLoad() {
        
        self.titleLabel.text = self.step?.title
        self.textLabel.text = self.step?.text
        
        if self.hasNextStep() {
            self.continueButton.setTitle("Next", for: .normal)
        }
        else {
            self.continueButton.setTitle("Done", for: .normal)
        }
        
        if !type(of: self).showsContinueButton {
            self.footerHeight.constant = RSQuestionViewController.footerHeightWithoutContinueButton
        }
        
    }
    
    open func notifyDelegateAndMoveForward() {
        if let delegate = self.delegate {
            delegate.stepViewControllerResultDidChange(self)
        }
        self.goForward()
    }
    
    open func validate() -> Bool {
        return true
    }
    
    open func clearAnswer() {
        self.skipped = true
    }
    
    @IBAction func continueTapped(_ sender: Any) {
        if self.validate() {
            self.notifyDelegateAndMoveForward()
        }
    }
    
    @IBAction func skipTapped(_ sender: Any) {
        self.clearAnswer()
        self.notifyDelegateAndMoveForward()
    }
}
