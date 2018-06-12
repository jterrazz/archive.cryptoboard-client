//
//  RoundedButton.swift
//  cryptoboard
//
//  Created by Jean Baptiste TERRAZZONI on 12/06/2018.
//  Copyright © 2018 terrazzoni. All rights reserved.
//

import UIKit

class RoundedButton: UIButton {
    
    override var bounds: CGRect {
        didSet {
            self.layer.cornerRadius = bounds.height / 2
        }
    }

    public func styleForHoverGradient() {
        self.backgroundColor = UIColor.init(white: 1, alpha: 0.36)
        self.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        self.contentEdgeInsets = UIEdgeInsets.init(top: 12, left: 12, bottom: 12, right: 12)
    }

}
