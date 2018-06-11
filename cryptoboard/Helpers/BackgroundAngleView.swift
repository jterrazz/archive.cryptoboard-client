//
//  AngleView.swift
//  cryptoboard
//
//  Created by Jean Baptiste TERRAZZONI on 10/06/2018.
//  Copyright © 2018 terrazzoni. All rights reserved.
//

import Foundation
import UIKit

class BackgroundAngleView: UIView {
    
    var gradientColors: [CGColor] = [UIColor.white.cgColor, UIColor.black.cgColor]
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = UIColor.clear
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        backgroundColor = UIColor.clear
    }
    
    override func draw(_ rect: CGRect) {
        let size = self.bounds.size
        let h = size.height * 0.8
        
        let p1 = self.bounds.origin
        let p2 = CGPoint(x: p1.x + size.width, y: p1.y)
        let p3 = CGPoint(x: p2.x, y: p2.y + h)
        let p4 = CGPoint(x: p1.x, y: size.height)
        
        let path = UIBezierPath()
        path.move(to: p1)
        path.addLine(to: p2)
        path.addLine(to: p3)
        path.addLine(to: p4)
        path.close()
                
        let gradient = CAGradientLayer()
        gradient.frame = path.bounds
        gradient.colors = gradientColors
        
        let shapeMask = CAShapeLayer()
        shapeMask.path = path.cgPath
        gradient.mask = shapeMask
        
        layer.addSublayer(gradient)
    }
    
    
}
