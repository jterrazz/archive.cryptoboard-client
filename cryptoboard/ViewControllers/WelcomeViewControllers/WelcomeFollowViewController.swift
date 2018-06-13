//
//  WelcomeFollowViewController.swift
//  cryptoboard
//
//  Created by Jean Baptiste TERRAZZONI on 12/06/2018.
//  Copyright © 2018 terrazzoni. All rights reserved.
//

import Foundation
import UIKit

class WelcomeFollowViewController: UIViewController {
    
    let TABLEVIEW_TOP_CONSTRAINT: CGFloat = 32
    let TABLEVIEW_SIDE_CONSTRAINT: CGFloat = 32
    
    lazy var nextButton = RoundedButton()
    lazy var waveBackground = WaveView()
    lazy var followContainer = FollowCoinView()
    lazy var titleLabel = UILabel()
    
    lazy var backButton: UIButton = {
        let image = UIImage(named: "left-arrow", in: Bundle.main, compatibleWith: nil)?.withRenderingMode(.alwaysTemplate)
        let button = UIButton(type: .custom)
        
        button.setImage(image, for: .normal)
        button.tintColor = UIColor.white
        button.contentMode = .scaleAspectFit
        
        return button
    }()
    
    var followContainerTopConstraint: NSLayoutConstraint?
    var followContainerLeftConstraint: NSLayoutConstraint?
    var followContainerRightConstraint: NSLayoutConstraint?
    
    // TODO Add animation to say loading coin list
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupViews()
        
        CurrencyController.getList(limit: 999999) { (currencies) in
            self.followContainer.coinList = currencies
            self.followContainer.setDataForEmptySearch()
        }
        
        nextButton.addTarget(self, action: #selector(triggerNextButton(_:)), for: .touchUpInside)
        backButton.addTarget(self, action: #selector(triggerBackButton(_:)), for: .touchUpInside)
    }
    
    private func setupViews() {
        view.backgroundColor = UIColor.clear
        view.clipsToBounds = true
        
        waveBackground.opposite = true
        followContainer.backgroundColor = UIColor.theme.bg.value
        followContainer.layer.cornerRadius = K.Design.CornerRadius
        followContainer.addShadow()
        followContainer.layer.borderWidth = 1
        followContainer.layer.borderColor = UIColor.theme.border.value.cgColor
        followContainer.delegate = self
        
        titleLabel.font = UIFont.systemFont(ofSize: 18, weight: .semibold)
        titleLabel.text = "Pick your favorites coins"
        titleLabel.textColor = UIColor.white
        
        nextButton.styleForHoverGradient()
        nextButton.setTitle("CONFIRM", for: .normal)
        
        view.addSubviewsAutoConstraints([nextButton, waveBackground, followContainer, titleLabel, backButton])
        setupConstraints()
    }
    
    private func setupConstraints() {
        let views = [
            "wave": waveBackground,
            "back": backButton
        ]
        let constraints = [
            "H:|[wave]|",
            "V:[wave(320)]",
            "H:|-16-[back(20)]",
            "V:[back(20)]",
            ]
        
        NSLayoutConstraint.visualConstraints(views: views, visualConstraints: constraints)
        
        followContainerTopConstraint = followContainer.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: TABLEVIEW_TOP_CONSTRAINT)
        followContainerLeftConstraint = followContainer.leftAnchor.constraint(equalTo: view.leftAnchor, constant: TABLEVIEW_SIDE_CONSTRAINT)
        followContainerRightConstraint = followContainer.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -TABLEVIEW_SIDE_CONSTRAINT)
        
        NSLayoutConstraint.activate([
            nextButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            nextButton.bottomAnchor.constraint(equalTo: view.safeBottomAnchor, constant: -64),
            nextButton.widthAnchor.constraint(equalToConstant: 200),
            waveBackground.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            followContainer.bottomAnchor.constraint(equalTo: nextButton.topAnchor, constant: -32),
            backButton.topAnchor.constraint(equalTo: view.safeTopAnchor, constant: 8),
            titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            titleLabel.topAnchor.constraint(equalTo: backButton.bottomAnchor, constant: 16),
            followContainerTopConstraint!,
            followContainerRightConstraint!,
            followContainerLeftConstraint!
            ])
    }
    
    @objc private func triggerNextButton(_ sender: UIButton) {
        let parentVC = self.parent as? WelcomeViewController
        let followed = self.followContainer.followedSymbols
        let settingsController = UserSettingsController()
        let settings = settingsController.get() != nil ? settingsController.get()! : UserSettings(localCurrency: .usd)
        
        settings.emptyFollowedCurrency()
        for follow in followed {
            settings.followCurrency(follow)
        }
        
        do {
            try settingsController.set(settings)
            
            parentVC?.setViewController(2)
        } catch {
            // TODO
        }
    }
    
    @objc private func triggerBackButton(_ sender: UIImageView) {
        let parentVC = self.parent as? WelcomeViewController
        
        parentVC?.setViewController(0)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch = touches.first
        guard let location = touch?.location(in: self.view) else { return }
        
        if (!followContainer.frame.contains(location)) {
            followContainer.searchBar.resignFirstResponder()
        }
    }
    
    
}

extension WelcomeFollowViewController: FollowCoinViewDelegate {
    
    func textFieldDidStartEditing() {
        followContainerTopConstraint?.constant = 16
        followContainerRightConstraint?.constant = -16
        followContainerLeftConstraint?.constant = 16
        animateChange()
    }
    
    func textFieldDidStopEditing() {
        followContainerTopConstraint?.constant = TABLEVIEW_TOP_CONSTRAINT
        followContainerRightConstraint?.constant = -TABLEVIEW_SIDE_CONSTRAINT
        followContainerLeftConstraint?.constant = TABLEVIEW_SIDE_CONSTRAINT
        animateChange()
    }
    
    private func animateChange() {
        UIView.animate(withDuration: K.Design.AnimationTime) {
            self.view.layoutIfNeeded()
        }
    }
    
    
}
