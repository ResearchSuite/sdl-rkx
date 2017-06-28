//
//  CTFDiscountingStepViewController.swift
//  Impulse
//
//  Created by James Kizer 6/27/17.
//  Copyright © 2017 Cornell Tech. All rights reserved.
//

import UIKit
import ResearchKit

class CTFDiscountingStepViewController: ORKStepViewController {
    
    static let totalAnimationDuration: TimeInterval = 0.2
    
    @IBOutlet weak var variableButton:CTFBorderedButton!
    @IBOutlet weak var constantButton:CTFBorderedButton!
    @IBOutlet weak var textLabel: UILabel!
    
    @IBOutlet weak var skipButton: UIButton!
    
    var _variableButtonHandler:(()->())?
    var _constantButtonHandler:(()->())?
    
    var trialResults:[CTFDiscountingTrialResult]?
    
    var currentTrial: CTFDiscountingTrial? = nil
    
    var canceled = false
    
    var discountingStep: CTFDiscountingStep! {
        return self.step as! CTFDiscountingStep
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        self.variableButton.tintColor = self.view.tintColor
        self.variableButton.titleLabel?.numberOfLines = 0
        self.variableButton.titleLabel?.textAlignment = NSTextAlignment.center
        self.constantButton.tintColor = self.view.tintColor
        self.constantButton.titleLabel?.numberOfLines = 0
        self.constantButton.titleLabel?.textAlignment = NSTextAlignment.center
        
        if let step = self.step,
            step.isOptional == false {
            self.skipButton.isHidden = true
        }
        
        guard let discoutingStep = self.step as? CTFDiscountingStep else {
            assertionFailure("Step must be CTFDiscountingStep")
            return
        }
        
        let variableString = String(format: self.discountingStep.variableFormatString, self.discountingStep.initialVariableAmount)
        let constantString = String(format: self.discountingStep.constantFormatString, self.discountingStep.constantAmount)
        self.variableButton.setTitle(variableString, for: .normal)
        self.constantButton.setTitle(constantString, for: .normal)
        self.textLabel.text = self.step?.text
        
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if let _ = self.currentTrial {
            return
        }
        
        let idList = Array(0..<self.discountingStep.numQuestions)
        let idListHead = idList.first!
        let idListTail = Array(idList.dropFirst())
        
        let firstTrial = CTFDiscountingTrial(
            variableAmount: self.discountingStep.initialVariableAmount,
            constantAmount: self.discountingStep.constantAmount,
            questionNum: idListHead
        )
        
        self.performTrials(firstTrial, trialIds: idListTail, results: [], completion: { (results) in
            if !self.canceled{
                self.trialResults = results
                self.goForward()
            }
        })
        
    }
   
    override convenience init(step: ORKStep?) {
        let framework = Bundle(for: CTFDiscountingStepViewController.self) //check nib creation - Francesco
        self.init(nibName: "CTFDiscountingStepViewController", bundle: framework)
        self.step = step
        self.restorationIdentifier = step!.identifier
    
    }
    
    
    func performTrials(_ trial:CTFDiscountingTrial, trialIds:[Int] ,results: [CTFDiscountingTrialResult],
                       completion: @escaping ([CTFDiscountingTrialResult]) -> ()) {
        if self.canceled {
            completion([])
            return
        }
        
        self.currentTrial = trial
        
        self.doTrial(trial) { (result) in
            var newResults = Array(results)
            newResults.append(result)
            if let head = trialIds.first{
                let tail = Array(trialIds.dropFirst())
                let nextTrial = self.createNewTrial(id: head , trialResults: newResults)!
                self.performTrials(nextTrial, trialIds: tail, results: newResults, completion:completion)
                
            }
            else{
                completion(newResults)
            }
        }
    }
    
    func createNewTrial(id: Int, trialResults: [CTFDiscountingTrialResult]) -> CTFDiscountingTrial? {
        
        guard let last = trialResults.last,
            let nextAmount = self.discountingStep.computeNextVariableAmount(trialResults) else {
            return nil
        }
        
        return CTFDiscountingTrial(
            variableAmount: nextAmount,
            constantAmount: last.trial.constantAmount,
            questionNum: id
        )
        
    }

    func doTrial(_ trial: CTFDiscountingTrial , completion: @escaping (CTFDiscountingTrialResult) -> ()) {

        var trialStartTime: Date!

        //fade in
        UIView.animate(withDuration: CTFDiscountingStepViewController.totalAnimationDuration / 2.0, animations: {
            
            let variableString = String(format: self.discountingStep.variableFormatString, trial.variableAmount)
            let constantString = String(format: self.discountingStep.constantFormatString, trial.constantAmount)
            self.variableButton.setTitle(variableString, for: .normal)
            self.constantButton.setTitle(constantString, for: .normal)
            
            self.variableButton.titleLabel?.alpha = 1.0
            self.constantButton.titleLabel?.alpha = 1.0
            
        }, completion: { (completed) in
            trialStartTime = Date()
            
            self.variableButton.isUserInteractionEnabled = true
            self.constantButton.isUserInteractionEnabled = true
        })

        
        func completeTrial(pressAction:CTFDiscountingChoice){
            
            self.variableButton.isUserInteractionEnabled = false
            self.constantButton.isUserInteractionEnabled = false
            
            let trialEndTime  = Date()
            let amount:Double = (pressAction == .variable) ? trial.variableAmount : trial.constantAmount
            let result = CTFDiscountingTrialResult(trial: trial,
                                                       choiceType: pressAction,
                                                       choiceValue: amount,
                                                       choiceTime: trialEndTime.timeIntervalSince(trialStartTime) * 1000)
            
            //fade out
            UIView.animate(withDuration: CTFDiscountingStepViewController.totalAnimationDuration / 2.0, animations: {
                
                self.variableButton.titleLabel?.alpha = 0.0
                self.constantButton.titleLabel?.alpha = 0.0
                
            }, completion: { completed in
                completion(result)
            })
        
        }
        
        self._variableButtonHandler = {
            self.variableButton.titleLabel?.alpha = 0.0
            completeTrial(pressAction: .variable)
        }
        self._constantButtonHandler = {
            self.constantButton.titleLabel?.alpha = 0.0
            completeTrial(pressAction: .constant)
        }
    }
    
    override var result: ORKStepResult? {
        guard let parentResult = super.result else {
            return nil
        }
        
        if let trialResults = self.trialResults {
            
            let ddResult = CTFDiscountingResult(identifier: step!.identifier)
            ddResult.startDate = parentResult.startDate
            ddResult.endDate = parentResult.endDate
            ddResult.trialResults = trialResults
            
            parentResult.results = [ddResult]
        }
        
        return parentResult
    }
    
    @IBAction func variableButtonPress(_ sender: AnyObject) {
      self._variableButtonHandler?()
        
    }
    
    @IBAction func constantButtonPress(_ sender: AnyObject) {
        self._constantButtonHandler?()
        
    }
    @IBAction func skipButtonPressed(_ sender: Any) {
        
        self.goForward()
        
    }

}
