//
//  ProgressView.swift
//  cryptoboard
//
//  Created by Jean Baptiste TERRAZZONI on 06/06/2018.
//  Copyright © 2018 terrazzoni. All rights reserved.
//

import UIKit

class ProgressView: UIView {
    
    var progressedView = UIView()
    var widthConstraint: NSLayoutConstraint?
    var colors = [CGColor]()

    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    private func commonInit() {
        clipsToBounds = true
        backgroundColor = UIColor.clear
        progressedView.layer.cornerRadius = 2
        widthConstraint = progressedView.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 1)
        addSubviewAutoConstraints(progressedView)
        
        NSLayoutConstraint.activate([
            progressedView.leftAnchor.constraint(equalTo: leftAnchor),
            progressedView.topAnchor.constraint(equalTo: topAnchor),
            progressedView.bottomAnchor.constraint(equalTo: bottomAnchor),
            widthConstraint!
        ])
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        progressedView.setGradient(colors: colors, angle: 90)
    }
    
    public func setup(_ progress: CGFloat, colors: [CGColor]) {
        self.colors = colors
        self.widthConstraint = widthConstraint?.setMultiplier(multiplier: progress)
    }
    

}
