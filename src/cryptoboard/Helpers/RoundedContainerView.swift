//
//  RoundedContainerView.swift
//  cryptoboard
//
//  Created by Jean Baptiste TERRAZZONI on 11/06/2018.
//  Copyright © 2018 terrazzoni. All rights reserved.
//

import UIKit

class RoundedContainerView: UIView {
    
    var roundedRadius: CGSize = CGSize.zero
    var corners: UIRectCorner = .allCorners
    
    convenience init (_ cornerRadius: CGFloat, corners: UIRectCorner) {
        self.init(frame: .zero)
        
        self.modifyCorners(cornerRadius, corners: corners)
        self.setNeedsDisplay()
    }
    
    override func draw(_ rect: CGRect) {
        let path = UIBezierPath.init(roundedRect: self.bounds, byRoundingCorners: corners, cornerRadii: roundedRadius)
        let maskLayer = CAShapeLayer()
        
        maskLayer.path = path.cgPath
        self.layer.mask = maskLayer
    }
    
    public func modifyCorners(_ cornerRadius: CGFloat, corners: UIRectCorner) {
        self.roundedRadius = CGSize.init(width: cornerRadius, height: cornerRadius)
        self.corners = corners
        self.setNeedsDisplay()
    }
    
    
}
