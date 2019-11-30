//
//  FollowCoinErrorCell.swift
//  cryptoboard
//
//  Created by Jean Baptiste TERRAZZONI on 14/06/2018.
//  Copyright © 2018 terrazzoni. All rights reserved.
//

import Foundation
import UIKit
import NVActivityIndicatorView

class FollowCoinErrorCell: UITableViewCell {
    
    lazy var logoColor = UIColor.theme.textDark.value
    lazy var logoView = UIImageView()
    lazy var stackView = UIStackView()
    lazy var descriptionLabel = UILabel()
    lazy var retryButton = RoundedButton()
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    var delegate: FollowCoinErrorCellDelegate?
    
    private func commonInit() {
        
        selectionStyle = .none
        contentView.addSubviewAutoConstraints(stackView)
        contentView.backgroundColor = UIColor.theme.bg.value
        
        retryButton.addTarget(self, action: #selector(self.didAskForReload(_:)), for: .touchUpInside)
        retryButton.setTitle("Retry", for: .normal)
        
        logoView.image = UIImage(named: "network-error-icon", in: Bundle.main, compatibleWith: nil)?.withRenderingMode(.alwaysTemplate)
        logoView.contentMode = .scaleAspectFit
        logoView.tintColor = UIColor.theme.textDark.value
        
        stackView.addArrangedSubview(logoView)
        stackView.addArrangedSubview(descriptionLabel)
        stackView.addArrangedSubview(retryButton)
        stackView.alignment = .center
        stackView.axis = .vertical
        stackView.spacing = 16
        descriptionLabel.textColor = UIColor.theme.textDark.value
        descriptionLabel.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        descriptionLabel.text = "Network error, click to retry"
        
        logoView.startAnimating()
        
        NSLayoutConstraint.activate([
            stackView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            stackView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            logoView.widthAnchor.constraint(equalToConstant: 42),
            logoView.heightAnchor.constraint(equalToConstant: 42),
            retryButton.widthAnchor.constraint(equalToConstant: 120)
            ])
    }
    
    @objc func didAskForReload(_ sender: UIButton) {
        delegate?.didAskForReload()
    }
    
    
}

protocol FollowCoinErrorCellDelegate {
    
    func didAskForReload()
    
    
}
