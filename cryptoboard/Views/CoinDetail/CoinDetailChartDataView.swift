//
//  CoinDetailChartDataView.swift
//  cryptoboard
//
//  Created by Jean Baptiste TERRAZZONI on 06/06/2018.
//  Copyright © 2018 terrazzoni. All rights reserved.
//

import UIKit
import AudioToolbox

class CoinDetailChartDataView: UIView {

    @IBOutlet var contentView: UIView!
    @IBOutlet weak var progressHour: ProgressView!
    @IBOutlet weak var progressDay: ProgressView!
    @IBOutlet weak var progressMonth: ProgressView!
    @IBOutlet weak var containerProgress: UIView!
    @IBOutlet weak var symbolLabel: UILabel!
    @IBOutlet weak var logoImageView: UIImageView!
    
    let followImage = UIImage(named: "heart", in: Bundle.main, compatibleWith: nil)
    let userSettingsController = UserSettingsController()
    
    var currency: Currency? {
        didSet {
            if let symbol = currency?.diminutive {
                UserSettingsController().isFollowingCurrency(symbol) ? followButton.select() : followButton.deselect()
            }
        }
    }
    
    lazy var followButton = FollowButton(frame: CGRect.init(x: 0, y: 0, width: 50, height: 50), image: followImage)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    private func commonInit() {
        Bundle.main.loadNibNamed("CoinDetailChartDataView", owner: self, options: nil)
        addSubview(contentView)
        contentView.frame = self.bounds
        contentView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        contentView.backgroundColor = UIColor.clear
        
        setupViews()
    }
    
    private func setupViews() {
        containerProgress.backgroundColor = UIColor.theme.darkBgHover.value
        containerProgress.layer.cornerRadius = K.Design.CornerRadius
        symbolLabel.textColor = UIColor.theme.textOnDark.value
        symbolLabel.font = UIFont.systemFont(ofSize: 14)
        followButton.addTarget(self, action: #selector(handleFollowClick(_:)), for: .touchUpInside)
        let progressGradient = [
            UIColor.theme.custom(hexString: "#feb692").value.cgColor,
            UIColor.theme.custom(hexString: "#ea5455").value.cgColor
        ]
        
        progressHour.setup(0.5, colors: progressGradient)
        progressDay.setup(0.2, colors: progressGradient)
        progressMonth.setup(0.2, colors: progressGradient)
        
        setupConstraints()
    }
    
    private func setupConstraints() {
        addSubviewAutoConstraints(followButton)
        NSLayoutConstraint.activate([
            followButton.centerYAnchor.constraint(equalTo: logoImageView.centerYAnchor),
            followButton.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: 0),
            followButton.heightAnchor.constraint(equalToConstant: 50),
            followButton.widthAnchor.constraint(equalToConstant: 50),
            ])
    }
    
    @objc private func handleFollowClick(_ sender: FollowButton) {
        if let safeCurrency = currency {
            do {
                if (sender.isSelected) {
                    try userSettingsController.update { (settings) in
                        sender.deselect()
                        settings.unfollowCurrency(safeCurrency.diminutive)
                    }
                    
                } else {
                    try userSettingsController.update { (settings) in
                        sender.select()
                        settings.followCurrency(safeCurrency.diminutive)
                    }
                    
                }
                AudioServicesPlaySystemSound(1519)
            } catch {
                // TODO Show error popup
            }
        }
    }
    

}
