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
    
    func addShadow(opacity: Float = 0.08) {
        self.layer.masksToBounds = false
        self.layer.shadowColor = UIColor.theme.shadow.value.cgColor
        self.layer.shadowOffset = CGSize(width: 0, height: 4)
        self.layer.shadowOpacity = opacity
//        self.layer.shadowPath = UIBezierPath(roundedRect: self.bounds, cornerRadius: self.layer.cornerRadius).cgPath
    }
    
    
}
