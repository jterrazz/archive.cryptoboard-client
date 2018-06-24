//
//  NSLayoutConstraint.swift
//  cryptoboard
//
//  Created by Jean Baptiste TERRAZZONI on 21/05/2018.
//  Copyright © 2018 terrazzoni. All rights reserved.
//

import UIKit

extension NSLayoutConstraint {
    
    static func visualConstraints(views: [String: Any], visualConstraints: [String]) {
        var constraints: [NSLayoutConstraint] = []
        
        for constraint in visualConstraints {
            constraints += NSLayoutConstraint.constraints(withVisualFormat: constraint, options: [], metrics: nil, views: views)
        }
        
        NSLayoutConstraint.activate(constraints)
    }
    
    func setMultiplier(multiplier:CGFloat) -> NSLayoutConstraint {
        
        NSLayoutConstraint.deactivate([self])

        let newConstraint = NSLayoutConstraint(
            item: firstItem,
            attribute: firstAttribute,
            relatedBy: relation,
            toItem: secondItem,
            attribute: secondAttribute,
            multiplier: multiplier,
            constant: constant)
        
        newConstraint.priority = priority
        newConstraint.shouldBeArchived = self.shouldBeArchived
        newConstraint.identifier = self.identifier
        
        NSLayoutConstraint.activate([newConstraint])
        return newConstraint
    }
    
    
}
