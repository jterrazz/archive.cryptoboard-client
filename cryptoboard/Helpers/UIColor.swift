//
//  UIColor.swift
//  cryptoboard
//
//  Created by Jean Baptiste TERRAZZONI on 19/05/2018.
//  Copyright © 2018 terrazzoni. All rights reserved.
//

import Foundation
import UIKit

fileprivate let COLOR_MAX: CGFloat = 255.0

extension UIColor {
    
    enum theme {
        case bg, border, textDark, textIntermediate, redClear, redDark, shadow, topBarEl, inputBg, blueClear
        case custom(hexString: String)

        func withAlpha(_ alpha: Double) -> UIColor {
            return self.value.withAlphaComponent(CGFloat(alpha))
        }
        
        var value: UIColor {
            switch self {
            case .bg:
                return UIColor(hex: "#F9FBFE")
            case .inputBg:
                return UIColor(hex: "#F3F6FB")
            case .border:
                return UIColor(hex: "#ECECEC")
            case .textDark:
                return UIColor(hex: "#4A5D69")
            case .textIntermediate:
                return UIColor(hex: "#768D9C")
            case .redClear:
                return UIColor(hex: "#F46251")
            case .redDark:
                return UIColor(hex: "#FC5462")
            case .blueClear:
                return UIColor(hex: "#00A6FB")
            case .shadow:
                return UIColor(hex: "#464646")
            case .topBarEl:
                return UIColor(hex: "#212121")
            case .custom(let hexValue):
                return UIColor(hex: hexValue)
            }
        }
    }
    
    convenience init(red: Int, green: Int, blue: Int) {
        assert(red >= 0 && green >= 0 && blue >= 0 && red <= 255 && green <= 255 && blue <= 255, "Color value should be between 0 and 255")
        
        self.init(red: CGFloat(red) / COLOR_MAX, green: CGFloat(green) / COLOR_MAX, blue: CGFloat(blue) / COLOR_MAX, alpha: 1.0)
    }
    
    // TODO: Go back on that
    convenience init(hex: String) {
        let hexString: String = (hex as NSString).trimmingCharacters(in: .whitespacesAndNewlines)
        let scanner = Scanner(string: hexString as String)
        
        if hexString.hasPrefix("#") {
            scanner.scanLocation = 1
        }
        var color: UInt32 = 0
        scanner.scanHexInt32(&color)
        
        let mask = 0x000000FF
        let r = Int(color >> 16) & mask
        let g = Int(color >> 8) & mask
        let b = Int(color) & mask
        
        let red   = CGFloat(r) / COLOR_MAX
        let green = CGFloat(g) / COLOR_MAX
        let blue  = CGFloat(b) / COLOR_MAX
        self.init(red: red, green: green, blue: blue, alpha: 1)
    }
    
    
}
