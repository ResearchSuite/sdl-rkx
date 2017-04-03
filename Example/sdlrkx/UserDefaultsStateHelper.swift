//
//  UserDefaultsStateHelper.swift
//  sdlrkx
//
//  Created by James Kizer on 4/2/17.
//  Copyright © 2017 CocoaPods. All rights reserved.
//

import UIKit
import ResearchSuiteTaskBuilder

class UserDefaultsStateHelper: RSTBStateHelper {
    
    func valueInState(forKey: String) -> NSSecureCoding? {
        return UserDefaults().object(forKey: forKey) as? NSSecureCoding
    }
    func setValueInState(value: NSSecureCoding?, forKey: String) {
        UserDefaults().set(value, forKey: forKey)
    }

}
