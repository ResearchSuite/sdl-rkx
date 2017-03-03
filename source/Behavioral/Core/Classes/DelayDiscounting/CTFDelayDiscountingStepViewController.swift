//
//  CTFDelayDiscountingStepViewController.swift
//  Impulse
//
//  Created by Francesco Perera on 10/25/16.
//  Copyright © 2016 Cornell Tech. All rights reserved.
//

import UIKit
import ResearchKit




class CTFDelayDiscountingStepViewController: ORKStepViewController {
    
    static let totalAnimationDuration: TimeInterval = 0.2
    
    //UI Elements
//    @IBOutlet weak var nowLabel: UILabel!
//    @IBOutlet weak var laterLabel:UILabel!
    @IBOutlet weak var nowButton:CTFBorderedButton!
    @IBOutlet weak var laterButton:CTFBorderedButton!
    @IBOutlet weak var promptLabel: UILabel!
    
    @IBOutlet weak var skipButton: UIButton!
    
    var _nowButtonHandler:(()->())?
    var _laterButtonHandler:(()->())?
    
    var trialResults:[CTFDelayDiscountingTrialResult]?
    
    var currentTrial: CTFDelayDiscountingTrial? = nil
    
    var canceled = false
    
    var stepParams: CTFDelayDiscountingStepParams?{
        guard let delayDiscoutingStep = self.step as? CTFDelayDiscountingStep,
            let params = delayDiscoutingStep.params
            else {
                return nil
        }
        return params
    }


    override func viewDidLoad() {
        super.viewDidLoad()

        self.nowButton.tintColor = self.view.tintColor
        self.nowButton.titleLabel?.numberOfLines = 0
        self.nowButton.titleLabel?.textAlignment = NSTextAlignment.center
        self.laterButton.tintColor = self.view.tintColor
        self.laterButton.titleLabel?.numberOfLines = 0
        self.laterButton.titleLabel?.textAlignment = NSTextAlignment.center
        
        if let step = self.step,
            step.isOptional == false {
            self.skipButton.isHidden = true
        }
        
        if let stepParams = self.stepParams {
            
            let firstTrial = self.firstTrial(stepParams: stepParams, trialId: 0)
            
            // link UI to Trial params
            let nowString = String(format: stepParams.formatString, firstTrial.now) + "\n\(stepParams.nowDescription as String)"
            let laterString = String(format: stepParams.formatString, firstTrial.later) + "\n\(stepParams.laterDescription as String)"
            self.nowButton.setTitle(nowString, for: .normal)
            self.laterButton.setTitle(laterString, for: .normal)
            self.promptLabel.text = stepParams.prompt
            
            
        }
        
    }
    
    func firstTrial(stepParams: CTFDelayDiscountingStepParams, trialId: Int) -> CTFDelayDiscountingTrial {
        return CTFDelayDiscountingTrial(now: stepParams.maxAmount/2,
                                        later: stepParams.maxAmount,
                                        questionNum: trialId,
                                        differenceValue: stepParams.maxAmount/4)
    }
    
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if let _ = self.currentTrial {
            return
        }
        
        if let stepParams = self.stepParams{
            
            let idList = Array(0..<stepParams.numQuestions)
            let idListHead = idList.first!
            let idListTail = Array(idList.dropFirst())
            
            let firstTrial = self.firstTrial(stepParams: stepParams, trialId: idListHead)
            
            self.performTrials(firstTrial, trialIds: idListTail, results: [], completion: { (results) in
                if !self.canceled{
                    self.trialResults = results
                    self.goForward()
                }
            })

        }
        
    }
   
    override convenience init(step: ORKStep?) {
        let framework = Bundle(for: CTFDelayDiscountingStepViewController.self) //check nib creation - Francesco
        self.init(nibName: "CTFDelayDiscountingStepViewController", bundle: framework)
        self.step = step
        self.restorationIdentifier = step!.identifier
    
    }
    
    
    func performTrials(_ trial:CTFDelayDiscountingTrial, trialIds:[Int] ,results: [CTFDelayDiscountingTrialResult],
                       completion: @escaping ([CTFDelayDiscountingTrialResult]) -> ()) {
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
                let nextTrial = self.createNewTrial(id: head , result: result)
                self.performTrials(nextTrial, trialIds: tail, results: newResults, completion:completion)
                
            }
            else{
                completion(newResults)
            }
        }
    }
    
    func createNewTrial(id:Int,result:CTFDelayDiscountingTrialResult)-> CTFDelayDiscountingTrial{
        let newNow = (result.choiceType == CTFDelayDiscountingChoice.Now) ? result.trial.now - result.trial.differenceValue : result.trial.now + result.trial.differenceValue
        let newDifference = result.trial.differenceValue/2
        
        return CTFDelayDiscountingTrial(now:newNow, later: result.trial.later, questionNum: id, differenceValue: newDifference)
    }

    func doTrial(_ trial: CTFDelayDiscountingTrial , completion: @escaping (CTFDelayDiscountingTrialResult) -> ()) {

        var trialStartTime: Date!

        //fade in
        UIView.animate(withDuration: CTFDelayDiscountingStepViewController.totalAnimationDuration / 2.0, animations: {
            
            if let stepParams = self.stepParams{
                // link UI to Trial params
                let nowString = String(format: stepParams.formatString, trial.now) + "\n\(stepParams.nowDescription as String)"
                let laterString = String(format: stepParams.formatString, trial.later) + "\n\(stepParams.laterDescription as String)"
                self.nowButton.setTitle(nowString, for: .normal)
                self.laterButton.setTitle(laterString, for: .normal)
                
            }
            
            self.nowButton.titleLabel?.alpha = 1.0
            self.laterButton.titleLabel?.alpha = 1.0
            
        }, completion: { (completed) in
            trialStartTime = Date()
            
            self.nowButton.isUserInteractionEnabled = true
            self.laterButton.isUserInteractionEnabled = true
        })

        
        func completeTrial(pressAction:CTFDelayDiscountingChoice){
            
            self.nowButton.isUserInteractionEnabled = false
            self.laterButton.isUserInteractionEnabled = false
            
            let trialEndTime  = Date()
            let amount:Double = (pressAction == .Now) ? trial.now : trial.later
            let result = CTFDelayDiscountingTrialResult(trial: trial,
                                                       choiceType: pressAction,
                                                       choiceValue: amount,
                                                       choiceTime: trialEndTime.timeIntervalSince(trialStartTime) * 1000)
            
            //fade out
            UIView.animate(withDuration: CTFDelayDiscountingStepViewController.totalAnimationDuration / 2.0, animations: {
                
                self.nowButton.titleLabel?.alpha = 0.0
                self.laterButton.titleLabel?.alpha = 0.0
                
            }, completion: { completed in
                completion(result)
            })
        
        }
        
        self._nowButtonHandler = {
            self.nowButton.titleLabel?.alpha = 0.0
            completeTrial(pressAction:CTFDelayDiscountingChoice.Now)
        }
        self._laterButtonHandler = {
            self.laterButton.titleLabel?.alpha = 0.0
            completeTrial(pressAction:CTFDelayDiscountingChoice.Later)
        }
    }
    
    override var result: ORKStepResult? {
        guard let parentResult = super.result else {
            return nil
        }
        
        if let trialResults = self.trialResults {
            
            let ddResult = CTFDelayDiscountingResult(identifier: step!.identifier)
            ddResult.startDate = parentResult.startDate
            ddResult.endDate = parentResult.endDate
            ddResult.trialResults = trialResults
            
            parentResult.results = [ddResult]
        }
        
        return parentResult
    }
    
    @IBAction func nowButtonPress(_ sender: AnyObject) {
      self._nowButtonHandler?()
        
    }
    
    @IBAction func laterButtonPress(_ sender: AnyObject) {
        self._laterButtonHandler?()
        
    }
    @IBAction func skipButtonPressed(_ sender: Any) {
        
        self.goForward()
        
    }

}
