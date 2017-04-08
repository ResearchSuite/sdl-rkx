//
//  CTFQuestionTableViewStep.swift
//  Pods
//
//  Created by James Kizer on 4/6/17.
//
//

import UIKit
import ResearchKit

open class CTFQuestionTableViewStep: ORKStep {
   
    override open func stepViewControllerClass() -> AnyClass {
        return CTFQuestionTableViewController.self
    }

}
