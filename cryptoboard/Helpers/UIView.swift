//
//  UIVIew.swift
//  cryptoboard
//
//  Created by Jean Baptiste TERRAZZONI on 19/05/2018.
//  Copyright © 2018 terrazzoni. All rights reserved.
//

import Foundation
import UIKit

extension UIView {
    
    // Gradient
    func applyGradient(colours: [UIColor]) {
        clipsToBounds = true
        let gradient = CAGradientLayer()
        gradient.frame = self.bounds
        gradient.colors = colours.map { $0.cgColor }
        
        self.layer.insertSublayer(gradient, at: 0)
    }
    
    // Shadows
    func addShadow(opacity: Float = 0.08) {
        self.layer.masksToBounds = false
        self.layer.shadowColor = UIColor.theme.shadow.value.cgColor
        self.layer.shadowOffset = CGSize(width: 0, height: 4)
        self.layer.shadowOpacity = opacity
//        self.layer.shadowPath = UIBezierPath(roundedRect: self.bounds, cornerRadius: self.layer.cornerRadius).cgPath
    }
    
    // Constraints
    var safeTopAnchor: NSLayoutYAxisAnchor {
        if #available(iOS 11.0, *) {
            return self.layoutMarginsGuide.topAnchor
        } else {
            return self.topAnchor
        }
    }
    
    var safeLeftAnchor: NSLayoutXAxisAnchor {
        if #available(iOS 11.0, *){
            return self.layoutMarginsGuide.leftAnchor
        }else {
            return self.leftAnchor
        }
    }
    
    var safeRightAnchor: NSLayoutXAxisAnchor {
        if #available(iOS 11.0, *){
            return self.layoutMarginsGuide.rightAnchor
        }else {
            return self.rightAnchor
        }
    }
    
    var safeBottomAnchor: NSLayoutYAxisAnchor {
        if #available(iOS 11.0, *) {
            return self.layoutMarginsGuide.bottomAnchor
        } else {
            return self.bottomAnchor
        }
    }
    
    
}
