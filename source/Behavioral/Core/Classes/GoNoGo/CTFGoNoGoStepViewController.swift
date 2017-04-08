//
//  CTFGoNoGoStepViewController.swift
//  ORKCatalog
//
//  Created by James Kizer on 9/29/16.
//  Copyright © 2016 researchkit.org. All rights reserved.
//

import UIKit
import ResearchKit

class CTFGoNoGoStepViewController: ORKStepViewController, CTFGoNoGoViewDelegate {

    
    @IBOutlet weak var goNoGoView: CTFGoNoGoView!
    @IBOutlet weak var feedbackLabel: UILabel!
    
    var correctFeedbackColor: UIColor? = UIColor(red: 52.0/255.0, green: 152.0/255.0, blue: 219.0/255.0, alpha: 1.0)
    var incorrectFeedbackColor: UIColor? = UIColor(red: 231.0/255.0, green: 76.0/255.0, blue: 60.0/255.0, alpha: 1.0)
    
    var trials: [CTFGoNoGoTrial]?
    var trialResults: [CTFGoNoGoTrialResult]?
    
    var paused = false
    var pendingTrials: [CTFGoNoGoTrial]?
    var pendingTrialResults: [CTFGoNoGoTrialResult]?
    var backgroundObserver: NSObjectProtocol!
    var foregroundObserver: NSObjectProtocol!
    
    @IBOutlet weak var skipButton: UIButton!
    
    
    var tapTime: Date? = nil
    
    var canceled = false
    
    let RFC3339DateFormatter = DateFormatter()
    
    override init(nibName nibNameOrNil: String!, bundle nibBundleOrNil: Bundle!) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    override convenience init(step: ORKStep?) {
        let framework = Bundle(for: CTFGoNoGoStepViewController.self)
        self.init(nibName: "CTFGoNoGoStepViewController", bundle: framework)
        self.step = step
        self.restorationIdentifier = step!.identifier
//        self.restorationClass = CTFGoNoGoStepViewController.self
        guard let goNoGoStep = self.step as? CTFGoNoGoStep,
        let params = goNoGoStep.goNoGoParams else {
            return
        }
        self.trials = self.generateTrials(params)
        
//        NotificationCenter.default.addObserver(self, selector: Selector("handleDidEnterBackground"), N
        
        let backgroundNotification: Notification.Name = NSNotification.Name.UIApplicationDidEnterBackground
        self.backgroundObserver = NotificationCenter.default.addObserver(forName: backgroundNotification, object: nil, queue: nil) { [weak self] (notification) in
            
            self?.paused = true
            
        }
        
        let foregroudNotification: Notification.Name = NSNotification.Name.UIApplicationDidBecomeActive
        self.foregroundObserver = NotificationCenter.default.addObserver(forName: foregroudNotification, object: nil, queue: nil) { [weak self] (notification) in
            
            self?.paused = false
            
        }
        
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self.backgroundObserver)
        NotificationCenter.default.removeObserver(self.foregroundObserver)
    }
    
    
    
    
    func generateTrials(_ goNoGoParams:CTFGoNoGoStepParameters) -> [CTFGoNoGoTrial]? {
        if let numTrials = goNoGoParams.numTrials {
            return (0..<numTrials).map { index in
                let cueTime: TimeInterval = (goNoGoParams.cueTimeOptions?.random())!
                let cueType: CTFGoNoGoCueType = coinFlip(CTFGoNoGoCueType.go, obj2: CTFGoNoGoCueType.noGo)
                let goCueGoTargetProbability: Float = Float(goNoGoParams.goCueTargetProb ?? 0.7)
                let noGoCueGoTargetProbability: Float = 1.0 - Float(goNoGoParams.noGoCueTargetProb ?? 0.7)
                let targetType: CTFGoNoGoTargetType = coinFlip(CTFGoNoGoTargetType.go, obj2: CTFGoNoGoTargetType.noGo, bias: (cueType == CTFGoNoGoCueType.go) ? goCueGoTargetProbability: noGoCueGoTargetProbability)
                
                return CTFGoNoGoTrial(
                    waitTime: goNoGoParams.waitTime,
                    crossTime: goNoGoParams.crossTime,
                    blankTime: goNoGoParams.blankTime,
                    cueTime: cueTime,
                    fillTime: goNoGoParams.fillTime,
                    cue: cueType,
                    target: targetType,
                    trialIndex: index)
                
            }
        }
        else {
            return nil
        }
    }
    
    public convenience override init(step: ORKStep?, result: ORKResult?) {
        self.init(step: step)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        self.RFC3339DateFormatter.locale = Locale(identifier: "en_US_POSIX")
        self.RFC3339DateFormatter.dateFormat = "HH:mm:ss.SSS"
        
        self.goNoGoView.delegate = self

        // Do any additional setup after loading the view.
        
        if let step = self.step,
            step.isOptional == false {
            self.skipButton.isHidden = true
        }
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        //note that this probably only works because of the passcode being displayed over when bringing back from background
        //maybe add a ui element if we are paused and allow us to continue?
        if let trials = self.pendingTrials,
            let trialResults = self.pendingTrialResults {
            self.performTrials(trials, results: trialResults, completion: { (results) in
                //                print(results)
                
                
                if !self.canceled {
                    self.trialResults = results
                    self.goForward()
                }
            })
        }
        else if let trials = self.trials {
            self.performTrials(trials, results: [], completion: { (results) in
                //                print(results)
                
                
                if !self.canceled {
                    //set results
                    // results is a list that contains all the trial results - Francesco
                    //aggregateResults is a dictionary of 4 CTFGoNoGoResults structs - Francesco
                    //                    let aggregateResults = self.calculateAllAggregateResults(results)
                    //                    print(aggregateResults)
                    self.trialResults = results
                    self.goForward()
                }
            })
        }
        
        
        
    }
    
//    override func viewWillDisappear(_ animated: Bool) {
//        super.viewWillDisappear(animated)
//        self.canceled = true
//    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override var result: ORKStepResult? {
        guard let parentResult = super.result else {
            return nil
        }
        
        if let trialResults = self.trialResults {
            
            let goNoGoResult = CTFGoNoGoResult(identifier: step!.identifier)
            goNoGoResult.startDate = parentResult.startDate
            goNoGoResult.endDate = parentResult.endDate
            goNoGoResult.trialResults = trialResults
            
            parentResult.results = [goNoGoResult]
        }
        
        return parentResult
    }
    
    func performTrials(_ trials: [CTFGoNoGoTrial], results: [CTFGoNoGoTrialResult], completion: @escaping ([CTFGoNoGoTrialResult]) -> ()) {
        
        if self.paused {
            self.pendingTrials = trials
            self.pendingTrialResults = results
            return
        }
        
        if self.canceled {
            completion([])
            return
        }
        if let head = trials.first {
            let tail = Array(trials.dropFirst())
            self.doTrial(head, completion: { (result) in
                var newResults = Array(results)
                newResults.append(result)
                self.performTrials(tail, results: newResults, completion: completion)
            })
        }
        else {
            completion(results)
        }
    }
    
    func delay(_ delay:TimeInterval, closure:@escaping ()->()) {
        DispatchQueue.main.asyncAfter(
            deadline: DispatchTime.now() + Double(Int64(delay * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC), execute: closure)
    }
    
    //impliment trial
    func doTrial(_ trial: CTFGoNoGoTrial, completion: @escaping (CTFGoNoGoTrialResult) -> ()) {
        
        let delay = self.delay
        let goNoGoView = self.goNoGoView
        
        goNoGoView?.state = CTFGoNoGoState.blank
        
//        print("Trial number \(trial.trialIndex)")
        
        delay(trial.waitTime) {
            
            goNoGoView?.state = CTFGoNoGoState.cross
            
            delay(trial.crossTime) {
                
                goNoGoView?.state = CTFGoNoGoState.blank
                
                delay(trial.blankTime) {
                    
                    if trial.cue == CTFGoNoGoCueType.go {
                        goNoGoView?.state = CTFGoNoGoState.goCue
                    }
                    else {
                        goNoGoView?.state = CTFGoNoGoState.noGoCue
                    }
                    
                    delay(trial.cueTime!) {
                        
                        if trial.cue == CTFGoNoGoCueType.go {
                            if trial.target == CTFGoNoGoTargetType.go {
                                goNoGoView?.state = CTFGoNoGoState.goCueGoTarget
                            }
                            else {
                                goNoGoView?.state = CTFGoNoGoState.goCueNoGoTarget
                            }
                            
                        }
                        else {
                            if trial.target == CTFGoNoGoTargetType.go {
                                goNoGoView?.state = CTFGoNoGoState.noGoCueGoTarget
                            }
                            else {
                                goNoGoView?.state = CTFGoNoGoState.noGoCueNoGoTarget
                            }
                        }
                        
                        //race for tap and timer expiration
                        let startTime: NSDate = NSDate()
//                        print("Start time: \(self.RFC3339DateFormatter.string(from: startTime as Date))")
                        self.tapTime = nil
                        
                        delay(trial.fillTime) {
                            let tapped = self.tapTime != nil
                            let responseTime: TimeInterval = (tapped ? self.tapTime!.timeIntervalSince(startTime as Date) : trial.fillTime) * 1000
                            
//                            if let tapTime = self.tapTime {
//                                print("Tapped Handler: \(self.RFC3339DateFormatter.string(from: tapTime))")
//                            }
                            
                            goNoGoView?.state = CTFGoNoGoState.blank
                            
                            if tapped {
                                if trial.target == CTFGoNoGoTargetType.go {
                                    self.feedbackLabel.text = "Correct! \(String(format: "%0.0f", responseTime)) ms"
                                    self.feedbackLabel.textColor = self.correctFeedbackColor
                                }
                                else {
                                    self.feedbackLabel.text = "Incorrect"
                                    self.feedbackLabel.textColor = self.incorrectFeedbackColor
                                }
                                self.feedbackLabel.isHidden = false
                            }
                            delay(trial.waitTime) {
                                
                                let result = CTFGoNoGoTrialResult(trial: trial, responseTime: responseTime, tapped: tapped)
                                completion(result)
                            }
                            
                            delay(0.6) {
                                self.feedbackLabel.isHidden = true
                            }
                        }
                    }
                }
                
            }
            
        }
    }
    
    func goNoGoViewDidTap(_ goNoGoView: CTFGoNoGoView) {
        if self.tapTime == nil {
            self.tapTime = Date()
        }
    }
    
    @IBAction func skipButtonPressed(_ sender: Any) {
        
        self.goForward()
        
    }
}
