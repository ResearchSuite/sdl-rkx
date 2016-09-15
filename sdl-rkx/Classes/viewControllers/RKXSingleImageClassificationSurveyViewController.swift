//
//  RKXSingleImageClassificationSurveyViewController.swift
//  sdl-rkx
//
//  Created by James Kizer on 4/5/16.
//  Copyright © 2016 Cornell Tech Foundry. All rights reserved.
//

import UIKit
import ResearchKit

class RKXSingleImageClassificationSurveyViewController: ORKStepViewController {

    @IBOutlet weak var activityImageView: UIImageView!
    @IBOutlet weak var activityDescriptionLabel: UILabel!
    @IBOutlet weak var questionTextView: UITextView!
    @IBOutlet weak var buttonStackView: UIStackView!
    
    override init(nibName nibNameOrNil: String!, bundle nibBundleOrNil: NSBundle!) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    override convenience init(step: ORKStep?) {
        let framework = NSBundle(forClass: RKXSingleImageClassificationSurveyViewController.self)
        self.init(nibName: "RKXSingleImageClassificationSurveyViewController", bundle: framework)
        self.step = step
        self.restorationIdentifier = step!.identifier
        self.restorationClass = RKXSingleImageClassificationSurveyViewController.self
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    var buttons: [UIButton]?
    var buttonHeightContraints: [NSLayoutConstraint]?
    var buttonHeight: CGFloat = 60.0 {
        willSet(newHeight) {
            self.buttonHeightContraints?.forEach { constraint in
                constraint.constant = newHeight
            }
        }
    }
    
    var answer: protocol<NSCoding, NSCopying, NSObjectProtocol>?
    
    override var result: ORKStepResult? {
        guard let parentResult = super.result else {
            return nil
        }
        
        if let answer = self.answer {
            let step = self.step as? RKXSingleImageClassificationSurveyStep
            
            let questionResult = ORKChoiceQuestionResult(identifier: step!.identifier)
            questionResult.choiceAnswers = [answer]
            questionResult.startDate = parentResult.startDate
            questionResult.endDate = parentResult.endDate
            
            parentResult.results = [questionResult]
        }

        return parentResult
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard let step = self.step as? RKXSingleImageClassificationSurveyStep
            else {
                fatalError("Step property should have been set by now!")
            }
        
        self.activityImageView.image = step.image
        self.activityDescriptionLabel.text = step.title

        self.setupDifficultyButtons()
        
        self.setupQuestionTextView(step)
    }
    
    func setupQuestionTextView(step: RKXSingleImageClassificationSurveyStep) {
        
        self.questionTextView.text = step.text
        self.questionTextView.textAlignment = NSTextAlignment.Center
        self.questionTextView.font = UIFont.boldSystemFontOfSize(18.0)
        
    }
    
    //note that this was setupButtons, but changed due to namespace conlict
    func setupDifficultyButtons() {
        
        self.buttonStackView.layoutMarginsRelativeArrangement = true
        
        //clear existing buttons, if any
        if let buttons = self.buttons {
            buttons.forEach { button in
                button.removeFromSuperview()
            }
            self.buttons = nil
            self.buttonHeightContraints = nil
        }
        
        guard let step = self.step as? RKXSingleImageClassificationSurveyStep
            else {
                fatalError("Step property should have been set by now!")
        }
        
        guard let answerFormat = step.answerFormat as? ORKTextChoiceAnswerFormat
            else {
                fatalError("Answer Format Type must be ORKTextChoiceAnswerFormat")
        }
        
        self.buttons = answerFormat.textChoices.enumerate().map { (i, textChoice) in
            let button = RKXBorderedButton(type: UIButtonType.System)
            button.setTitle(textChoice.text, forState: .Normal)
            
            if let textChoiceWithColor = textChoice as? RKXTextChoiceWithColor {
                button.configuredColor = textChoiceWithColor.color
            }
            
            let heightContraint = NSLayoutConstraint(item: button, attribute: .Height, relatedBy: .Equal, toItem: nil, attribute: .NotAnAttribute, multiplier: 1.0, constant: self.buttonHeight)
            button.addConstraint(heightContraint)
            
            button.addTarget(self, action: #selector(RKXSingleImageClassificationSurveyViewController.textChoiceButtonSelected(_:)), forControlEvents: .TouchUpInside)
            
            return button
        }
        
        self.buttonHeightContraints = self.buttons!.map { button in
            let constraint: NSLayoutConstraint = NSLayoutConstraint(item: button, attribute: .Height, relatedBy: .Equal, toItem: nil, attribute: .NotAnAttribute, multiplier: 1.0, constant: self.buttonHeight)
            button.addConstraint(constraint)
            return constraint
        }
        
        self.buttons?.forEach(self.buttonStackView.addArrangedSubview)
    }
    
    func textChoiceAtIndex(index: Int) -> ORKTextChoice? {
        
        guard let step = self.step as? RKXSingleImageClassificationSurveyStep,
            let answerFormat = step.answerFormat as? ORKTextChoiceAnswerFormat
            else {
                return nil
            }
        
        return answerFormat.textChoices[index]
    }
    
    
    func textChoiceButtonSelected(button: UIButton) {
        
        
        if let buttonIndex = self.buttons?.indexOf(button),
            let textChoice = self.textChoiceAtIndex(buttonIndex) {
            
            self.answer = textChoice.value
            
            if let delegate = self.delegate {
                delegate.stepViewControllerResultDidChange(self)
            }
        }
        self.goForward()
        
    }

    @IBAction func skipButtonPressed(sender: AnyObject) {
        self.goForward()
    }

}
