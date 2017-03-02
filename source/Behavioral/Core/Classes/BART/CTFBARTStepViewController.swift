//
//  CTFBARTStepViewController.swift
//  Impulse
//
//  Created by James Kizer on 10/17/16.
//  Copyright © 2016 James Kizer. All rights reserved.
//

import UIKit
import ResearchKit

//extension Array where Element: Integer {
//    /// Returns the sum of all elements in the array
//    var total: Element {
//        return reduce(0, +)
//    }
//}
//extension Collection where Iterator.Element == Int, Index == Int {
//    /// Returns the average of all elements in the array
//    var average: Float {
//        return isEmpty ? 0 : Float(reduce(0, +)) / Float(endIndex-startIndex)
//    }
//}

open class CTFBARTStepViewController: ORKStepViewController {

    let initialScalingFactor: CGFloat = 10.0
    
    @IBOutlet weak var balloonContainerView: UIView!
    var balloonImageView: UIImageView!
    var balloonConstraints: [NSLayoutConstraint]?
    
    @IBOutlet weak var trialPayoutLabel: UILabel!
    @IBOutlet weak var totalPayoutLabel: UILabel!
    @IBOutlet weak var taskProgressLabel: UILabel!
    
    @IBOutlet weak var pumpButton: CTFBorderedButton!
    var _pumpButtonHandler:(() -> ())?
    @IBOutlet weak var collectButton: CTFBorderedButton!
    var _collectButtonHandler:(() -> ())?
    
    @IBOutlet weak var skipButton: UIButton!
    
    
    var trials: [CTFBARTTrial]?
    var trialsCount:Int {
        return self.trials?.count ?? 0
    }
    var trialResults: [CTFBARTTrialResult]?
    
    
    //pending trials and results
    var pendingTrials: [CTFBARTTrial]?
    var pendingResults: [CTFBARTTrialResult]?
    
    var canceled = false
    
    override init(nibName nibNameOrNil: String!, bundle nibBundleOrNil: Bundle!) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    override convenience init(step: ORKStep?) {
        let framework = Bundle(for: CTFBARTStepViewController.self)
        self.init(nibName: "CTFBARTStepViewController", bundle: framework)
        self.step = step
        self.restorationIdentifier = step!.identifier
        
        guard let bartStep = self.step as? CTFBARTStep,
            let params = bartStep.params
            else {
                return
        }
        
        self.trials = self.generateTrials(params: params)
    }
    
    public convenience override init(step: ORKStep?, result: ORKResult?) {
        self.init(step: step)
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
    
//    func generateSummary(slice: ArraySlice<(CTFBARTTrialResult, CTFBARTTrialResult?)>) -> CTFBARTResultSummary? {
//        
//        guard slice.count > 0 else {
//            return nil
//        }
//        
//        var summary = CTFBARTResultSummary()
//        
//        let pumpsArray: [Int] = slice.map({$0.0.numPumps})
//        
//        //mean
//        summary.meanNumberOfPumps = pumpsArray.average
//        
//        //range
//        summary.numberOfPumpsRange = pumpsArray.max()! - pumpsArray.min()!
//        
//        //std dev
//        let stdDevExpression = NSExpression(forFunction:"stddev:", arguments:[NSExpression(forConstantValue: pumpsArray)])
//        summary.numberOfPumpsStdDev = stdDevExpression.expressionValue(with: nil, context: nil) as? Float
//        
//        let pumpsAfterExplode: [Int] = slice.filter { (pair) -> Bool in
//            if let previousResult = pair.1 {
//                return previousResult.exploded
//            }
//            else {
//                return false
//            }
//        }.map({$0.0.numPumps})
//        
//        summary.meanNumberOfPumpsAfterExplosion = pumpsAfterExplode.average
//        
//        let pumpsAfterNoExplode: [Int] = slice.filter { (pair) -> Bool in
//            if let previousResult = pair.1 {
//                return !previousResult.exploded
//            }
//            else {
//                return false
//            }
//        }.map({$0.0.numPumps})
//        
//        summary.meanNumberOfPumpsAfterNoExplosion = pumpsAfterNoExplode.average
//        
//        summary.numberOfExplosions = slice.map({$0.0}).filter({$0.exploded}).count
//        
//        summary.numberOfBalloons = slice.count
//        
//        summary.totalWinnings = slice.map({$0.0.payout}).reduce(0.0, +)
//        
//        return summary
//    }
    
    override open var result: ORKStepResult? {
        guard let parentResult = super.result else {
            return nil
        }
        
        if let trialResults = self.trialResults {
            
            
//            var lastResult: CTFBARTTrialResult? = nil
//            
//            let pairArray: [(CTFBARTTrialResult, CTFBARTTrialResult?)] =
//                trialResults.map { result in
//                    
//                    let returnPair = (result, lastResult)
//                    lastResult = result
//                    return returnPair
//                    
//            }
//            
//            let bartResult = CTFBARTResult(identifier: step!.identifier)
//            bartResult.startDate = parentResult.startDate
//            bartResult.endDate = parentResult.endDate
//
//            bartResult.totalSummary = self.generateSummary(slice: ArraySlice(pairArray))
//            
//            bartResult.firstThirdSummary = self.generateSummary(slice: pairArray[0..<(pairArray.count/3)])
//            bartResult.secondThirdSummary = self.generateSummary(slice: pairArray[(pairArray.count/3)..<((2*pairArray.count)/3)])
//            bartResult.lastThirdSummary = self.generateSummary(slice: pairArray[((2*pairArray.count)/3)..<pairArray.count])
            
            
            let bartResult = CTFBARTResult(identifier: step!.identifier)
            bartResult.startDate = parentResult.startDate
            bartResult.endDate = parentResult.endDate
            bartResult.trialResults = trialResults
            
            parentResult.results = [bartResult]
        }
        
        return parentResult
    }
    
    
    func generateTrials(params: CTFBARTStepParams) -> [CTFBARTTrial]? {
        if let numTrials = params.numTrials {
            return (0..<numTrials).map { index in
                return CTFBARTTrial(
                    earningsPerPump: params.earningsPerPump,
                    maxPayingPumps: params.maxPayingPumpsPerTrial,
                    trialIndex: index,
                    canExplodeOnFirstPump: params.canExplodeOnFirstPump
                )
                
            }
        }
        else {
            return nil
        }
    }
    
    
    override open func viewDidLoad() {
        super.viewDidLoad()
        
//        self.pumpButton.configuredColor = self.view.tintColor
//        self.collectButton.configuredColor = self.view.tintColor
        
        if let step = self.step,
            step.isOptional == false {
            self.skipButton.isHidden = true
        }
        
        self.pumpButton.tintColor = self.view.tintColor
        self.collectButton.tintColor = self.view.tintColor

        // Do any additional setup after loading the view.
        if let trials = self.trials {
            self.setup(trials)
        }
        
        
    }
    
    override open func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        //if there are pending trials, don't reset
        if let _ = self.pendingTrials,
            let _ = self.pendingResults {
            return
        }
        
        //clear results
        if let trials = self.trials {
            self.performTrials(trials, results: [], completion: { (results) in
//                print(results)
                
                self.pendingTrials = nil
                self.pendingResults = nil
                
                if !self.canceled {
                    //set results
                    // results is a list that contains all the trial results - Francesco
                    //                    self.calculateAggregateResults(results)
                    self.trialResults = results
                    self.goForward()
                }
            })
        }
    }
    
    func setup(_ trials: [CTFBARTTrial]) {
    
        self.collectButton.isEnabled = false
        self.pumpButton.isEnabled = false
        
        self.taskProgressLabel.text = "Ballon 1 out of \(self.trialsCount)."
        self.totalPayoutLabel.text = "$0.00"
    }
    
    func setupImage() {
        
        if let oldConstraints = self.balloonConstraints?.filter({$0.isActive}),
            oldConstraints.count > 0 {
            NSLayoutConstraint.deactivate(oldConstraints)
        }
        
        if let imageView = self.balloonImageView,
            let _ = imageView.superview {
            
            imageView.removeFromSuperview()
            
        }
        
        let image = UIImage(named: "balloon", in: Bundle(for: CTFBARTStepViewController.self), compatibleWith: nil)
        self.balloonImageView = UIImageView(image: image)
        
        self.balloonImageView.alpha = 0.0
        let transform = self.balloonImageView.transform.scaledBy(
            x: 1.0 / self.initialScalingFactor,
            y: 1.0 / self.initialScalingFactor
        )
        
        self.balloonImageView.transform = transform
        self.balloonContainerView.addSubview(self.balloonImageView)
        self.balloonImageView.center = CGPoint(x: self.balloonContainerView.bounds.width/2.0, y: self.balloonContainerView.bounds.height/2.0)
        
    }
    
    
    func performTrials(_ trials: [CTFBARTTrial], results: [CTFBARTTrialResult], completion: @escaping ([CTFBARTTrialResult]) -> ()) {
        
        self.pendingTrials = trials
        self.pendingResults = results
        
        //set the task progress label and total payout label
        self.taskProgressLabel.text = "Ballon \(results.count + 1) out of \(self.trialsCount)."
        
        let totalPayout: Float = results.reduce(0.0) { (acc, trialResult) -> Float in
            return acc + trialResult.payout
        }
        let monitaryValueString = String(format: "%.2f", totalPayout)
        self.totalPayoutLabel.text = "$\(monitaryValueString)"
        
        if self.canceled {
            completion([])
            return
        }
        if let head = trials.first {
            let tail = Array(trials.dropFirst())
            self.doTrial(head, results.count, completion: { (result) in
                var newResults = Array(results)
                newResults.append(result)
                
                self.performTrials(tail, results: newResults, completion: completion)
            })
        }
        else {
            completion(results)
        }
    }
    
    
    
    
    //impliment trial
    func doTrial(_ trial: CTFBARTTrial, _ index: Int, completion: @escaping (CTFBARTTrialResult) -> ()) {

        self.trialPayoutLabel.text = "$0.00"
        
        self.setupImage()
        
        func setupForPump(_ pumpCount: Int) {
            
            self._pumpButtonHandler = {
                
                //compute probability of pop
                //function of pump count
                //probability starts low and eventually gets to 1/2
                let popProb = ((trial.maxPayingPumps) >= pumpCount) ?
                    1.0 / Float( (trial.maxPayingPumps+2) - pumpCount) :
                    1.0 / 2.0
                
//                print(popProb)
                //note for coinFlip, p1 = bias = popProb, p2 = (1.0-bias) = !popProb
//                let popped: Bool = coinFlip(true, obj2: false, bias: popProb)
                let popped: Bool = {
                    
                    if !trial.canExplodeOnFirstPump && pumpCount == 0 {
                        return false
                    }
                    else {
                        return coinFlip(true, obj2: false, bias: popProb)
                    }
                    
                    
                }()
                
                if popped {
//                    print("should pop here")
                    
                    self.collectButton.isEnabled = false
                    self.pumpButton.isEnabled = false
                    
                    self.balloonImageView.lp_explode(callback: {
                        let result = CTFBARTTrialResult(
                            trial: trial,
                            numPumps: pumpCount+1,
                            payout: 0.0,
                            exploded: true
                        )
//                        self.setupImage()
                        completion(result)
                    })
                    
                }
                else {
                    
                    //set potential gain label
                    let monitaryValueString = String(format: "%.2f", trial.earningsPerPump * Float( min(trial.maxPayingPumps, pumpCount+1)))
                    self.trialPayoutLabel.text = "$\(monitaryValueString)"
                    
                    let increment: CGFloat = (self.view.frame.width / CGFloat(trial.maxPayingPumps * 1000)) * (8.0/(1.0 + CGFloat(pumpCount)))
                    
                    UIView.animate(
                        withDuration: 0.3,
                        delay: 0.0,
                        usingSpringWithDamping: 0.5,
                        initialSpringVelocity: 0.5,
                        options: UIViewAnimationOptions.curveEaseIn, animations: { 
                            let transform = self.balloonImageView.transform.scaledBy(
                                x: 1.0025 * (1.0+increment),
                                y: (1.0+increment)
                            )
                            
                            self.balloonImageView.transform = transform
                        },
                        completion: { (comleted) in
                            setupForPump(pumpCount + 1)
                    })
                }
                
            }
            
            self._collectButtonHandler = {
                
                self.collectButton.isEnabled = false
                self.pumpButton.isEnabled = false
                
                // remove balloon
                UIView.animate(withDuration: 0.3, animations: { 
                    self.balloonImageView.alpha = 0.0
                    }, completion: { (completed) in
                        self.balloonImageView.removeFromSuperview()
                        
                        let result = CTFBARTTrialResult(
                            trial: trial,
                            numPumps: pumpCount,
                            payout: Float(min(trial.maxPayingPumps, pumpCount)) * trial.earningsPerPump,
                            exploded: false
                        )
                        
                        completion(result)
                })
                
                
            }

            self.view.isUserInteractionEnabled = true
            
            self.collectButton.isEnabled = pumpCount > 0
            self.pumpButton.isEnabled = true
            
        }
        
        UIView.animate(
            withDuration: 1.0,
            delay: 0.0,
            usingSpringWithDamping: 0.5,
            initialSpringVelocity: 0.5,
            options: UIViewAnimationOptions.curveEaseIn, animations: {
                self.balloonImageView.alpha = 1.0
                let transform = self.balloonImageView.transform.scaledBy(
                    x: self.initialScalingFactor,
                    y: self.initialScalingFactor
                )
                
                self.balloonImageView.transform = transform
            },
            completion: { (comleted) in
                setupForPump(0)
        })
        
    }
    
    
    @IBAction func pumpButtonPressed(_ sender: AnyObject) {
        self.view.isUserInteractionEnabled = false
        
        self._pumpButtonHandler?()
    }

    @IBAction func collectButtonPressed(_ sender: AnyObject) {
        self.view.isUserInteractionEnabled = false
        
        self._collectButtonHandler?()
    }
    @IBAction func skipButtonPressed(_ sender: Any) {
        
        self.goForward()
        
    }
}
