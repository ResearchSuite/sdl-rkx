//
//  BehavioralViewController.swift
//  sdlrkx
//
//  Created by James Kizer on 1/25/17.
//  Copyright © 2017 CocoaPods. All rights reserved.
//

import UIKit
import ResearchKit
import sdlrkx
import ResearchSuiteTaskBuilder

class BehavioralViewController: RKViewController {

    var taskBuilder: RSTBTaskBuilder!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let stepGeneratorServices: [RSTBStepGenerator] = [
            RSTBInstructionStepGenerator(),
            CTFDelayDiscountingStepGenerator(),
            CTFBARTStepGenerator(),
            RSTBSingleChoiceStepGenerator()
        ]
        
        let answerFormatGeneratorServices: [RSTBAnswerFormatGenerator] = [
            RSTBSingleChoiceStepGenerator()
        ]
        
        let elementGeneratorServices: [RSTBElementGenerator] = [
            RSTBElementListGenerator(),
            RSTBElementFileGenerator(),
            RSTBElementSelectorGenerator()
        ]
        
        // Do any additional setup after loading the view, typically from a nib.
        self.taskBuilder = RSTBTaskBuilder(
            stateHelper: nil,
            elementGeneratorServices: elementGeneratorServices,
            stepGeneratorServices: stepGeneratorServices,
            answerFormatGeneratorServices: answerFormatGeneratorServices)
        
    }

    @IBAction func launchDelayedDiscounting(_ sender: Any) {
        
        guard let steps = self.taskBuilder.steps(forElementFilename: "DelayedDiscounting") else { return }
        
        let task = ORKOrderedTask(identifier: "DelayedDiscounting", steps: steps)
        
        self.launchAssessmentForTask(task)
        
    }
    

    @IBAction func launchBART(_ sender: Any) {
        
        guard let steps = self.taskBuilder.steps(forElementFilename: "BART") else { return }
        
        let task = ORKOrderedTask(identifier: "BART", steps: steps)
        
        self.launchAssessmentForTask(task)
        
    }
}
