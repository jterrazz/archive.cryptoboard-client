//
//  MenuTitleCell.swift
//  cryptoboard
//
//  Created by Jean Baptiste TERRAZZONI on 22/05/2018.
//  Copyright © 2018 terrazzoni. All rights reserved.
//

import Foundation
import UIKit

class MenuTitleCell: UITableViewCell {
    
    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 26, weight: UIFont.Weight.bold)
        label.textColor = UIColor.theme.textDark.value
        
        return label
    }()
    
    lazy var waveBackground = WaveView()
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    private func commonInit() {
        backgroundColor = UIColor.clear
        selectionStyle = .none
        titleLabel.textColor = UIColor.white
        contentView.addSubviewsAutoConstraints([waveBackground, titleLabel])
        waveBackground.fillColor = UIColor.theme.redDark.value
        waveBackground.shadowColor = UIColor.white.cgColor
        waveBackground.shadowBlurRadius = 0
        waveBackground.heightMultiplier = 0.90
        waveBackground.opposite = true
        
        let views = [
            "title": titleLabel,
            "wave": waveBackground
        ]
        let constraints = [
            "V:|-32-[title]",
            "H:[title]-|",
            "V:|-(-210)-[wave(300)]-24-|",
            "H:|[wave]|",
        ]
        
        NSLayoutConstraint.visualConstraints(views: views, visualConstraints: constraints)
    }
    
    public func setup(title: String) {
        titleLabel.text = title
    }
    
    
}
