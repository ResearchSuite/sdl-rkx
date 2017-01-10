//
//  UIColor+String.swift
//  sdlrkx
//
//  Created by James Kizer on 4/5/16.
//  Copyright © 2016 Cornell Tech Foundry. All rights reserved.
//

import UIKit

extension UIColor {
    // Assumes input like "#00FF00" (#RRGGBB).
    convenience init(hexString: String) {
        let scanner = Scanner(string: hexString)
        scanner.scanLocation = 1
        var x: UInt32 = 0
        scanner.scanHexInt32(&x)
        let red: CGFloat = CGFloat((x & 0xFF0000) >> 16)/255.0
        let green: CGFloat = CGFloat((x & 0xFF00) >> 8)/255.0
        let blue: CGFloat = CGFloat(x & 0xFF)/255.0
        self.init(red: red, green: green, blue: blue, alpha:1.0)
    }
}
