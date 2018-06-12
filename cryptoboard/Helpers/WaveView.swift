//
//  WaveView.swift
//  cryptoboard
//
//  Created by Jean Baptiste TERRAZZONI on 12/06/2018.
//  Copyright © 2018 terrazzoni. All rights reserved.
//

import UIKit

class WaveView: UIView {

    var fillColor: UIColor = UIColor.white
    var gradientAngle: Float = 45
    var heightMultiplier: CGFloat = 0.75
    var opposite = false {
        didSet {
            setNeedsDisplay()
        }
    }
    
    var shadowColor = UIColor.black.cgColor
    var shadowOffset = CGSize(width: 1, height: 0)
    var shadowBlurRadius: CGFloat = 20

    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    private func commonInit() {
        backgroundColor = UIColor.clear
        layer.masksToBounds = false
        clipsToBounds = false
    }

    override func draw(_ rect: CGRect) {
        let size = self.bounds.size
        let origin = self.bounds.origin
        let h = size.height * heightMultiplier
        let hEmpty = size.height - h

        let p1 = CGPoint(x: origin.x, y: origin.y + (opposite ? 0 : hEmpty))
        let p3 = CGPoint(x: p1.x + size.width, y: origin.y + (!opposite ? 0 : hEmpty))
        let p2 = CGPoint(x: (p1.x + p3.x) / 2, y: (p1.y + p3.y) / 2) // Center of p1 & p3
        
        let p1Control = CGPoint(x: (p1.x + p2.x) / 2, y: p1.y)
        let p3Control = CGPoint(x: (p3.x + p2.x) / 2, y: p3.y)
        
        let p4 = CGPoint(x: p3.x, y: p3.y + h)
        let p6 = CGPoint(x: p1.x, y: p1.y + h)
        let p5 = CGPoint(x: (p4.x + p6.x) / 2, y: (p4.y + p6.y) / 2) // Center of p4 & p6
        
        let p4Control = CGPoint(x: (p4.x + p5.x) / 2, y: p4.y)
        let p6Control = CGPoint(x: (p6.x + p5.x) / 2, y: p6.y)

        let path = UIBezierPath()
        path.move(to: p1)
        path.addCurve(to: p3, controlPoint1: p1Control, controlPoint2: p3Control)
        path.addLine(to: p4)
        path.addCurve(to: p6, controlPoint1: p4Control, controlPoint2: p6Control)
        path.close()
        
        fillColor.setFill()
        path.fill()
        
        self.layer.shadowPath = path.cgPath
        self.layer.shadowColor = UIColor.black.cgColor
        self.layer.shadowOpacity = 0.4
        self.layer.shadowRadius = 12
        self.layer.shadowOffset = CGSize(width: 0, height: 2)
    }


}
