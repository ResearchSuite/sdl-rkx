//
//  RKViewController.swift
//  sdlrkx
//
//  Created by James Kizer on 1/25/17.
//  Copyright © 2017 CocoaPods. All rights reserved.
//

import UIKit
import ResearchKit

class RKViewController: UIViewController, ORKTaskViewControllerDelegate {
    
    /**
     When a task is completed, the `TaskListViewController` calls this closure
     with the created task.
     */
    var taskResultFinishedCompletionHandler: ((ORKTaskResult) -> Void)?
    
    func launchAssessmentForTask(_ task: ORKOrderedTask, completion: ((ORKTaskResult) -> Void)? = nil) {
        /*
         Passing `nil` for the `taskRunUUID` lets the task view controller
         generate an identifier for this run of the task.
         */
        let taskViewController = ORKTaskViewController(task: task, taskRun: nil)
        
        // Make sure we receive events from `taskViewController`.
        taskViewController.delegate = self
        
        // Assign a directory to store `taskViewController` output.
        taskViewController.outputDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        
        self.taskResultFinishedCompletionHandler = completion
        
        /*
         We present the task directly, but it is also possible to use segues.
         The task property of the task view controller can be set any time before
         the task view controller is presented.
         */
        present(taskViewController, animated: true, completion: nil)
    }
    
    func taskViewController(_ taskViewController: ORKTaskViewController, didFinishWith reason: ORKTaskViewControllerFinishReason, error: Error?) {
        
        if reason == ORKTaskViewControllerFinishReason.completed {
            self.taskResultFinishedCompletionHandler?(taskViewController.result)
        }
        
        taskViewController.dismiss(animated: true, completion: nil)
    }
    

}
