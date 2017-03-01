//
//  CTFGoNoGoGestureRecognizer.swift
//  Pods
//
//  Created by James Kizer on 3/1/17.
//
//

import UIKit

import UIKit
import UIKit.UIGestureRecognizerSubclass

class CTFGoNoGoGestureRecognizer: UIGestureRecognizer {
    
    let onBegin: ()->Void
    
    init(onBegin: @escaping ()->Void) {
        self.onBegin = onBegin
        super.init(target: nil, action: nil)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent) {
        super.touchesBegan(touches, with: event)
        state = .began
        onBegin()
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent) {
        super.touchesEnded(touches, with: event)
        state = .ended
    }
    
}

