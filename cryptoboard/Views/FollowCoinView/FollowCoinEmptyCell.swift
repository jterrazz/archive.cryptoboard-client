//
//  FollowCoinEmptyCell.swift
//  cryptoboard
//
//  Created by Jean Baptiste TERRAZZONI on 13/06/2018.
//  Copyright © 2018 terrazzoni. All rights reserved.
//

import Foundation
import UIKit
import NVActivityIndicatorView

class FollowCoinEmptyCell: UITableViewCell {
    
    lazy var logoColor = UIColor.theme.textDark.value
    lazy var logoView = NVActivityIndicatorView(frame: .zero, type: NVActivityIndicatorType.lineScalePulseOut, color: logoColor)
    lazy var stackView = UIStackView()
    lazy var descriptionLabel = UILabel()
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    private func commonInit() {
        
        selectionStyle = .none
        contentView.addSubviewAutoConstraints(stackView)
        contentView.backgroundColor = UIColor.theme.bg.value
        
        stackView.addArrangedSubview(logoView)
        stackView.addArrangedSubview(descriptionLabel)
        stackView.alignment = .center
        stackView.axis = .vertical
        stackView.spacing = 16
        descriptionLabel.textColor = UIColor.theme.textDark.value
        descriptionLabel.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        descriptionLabel.text = "Loading coin list"
        
        logoView.startAnimating()
        
        NSLayoutConstraint.activate([
            stackView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            stackView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            logoView.widthAnchor.constraint(equalToConstant: 42),
            logoView.heightAnchor.constraint(equalToConstant: 42)
            ])
    }
    
    
}
