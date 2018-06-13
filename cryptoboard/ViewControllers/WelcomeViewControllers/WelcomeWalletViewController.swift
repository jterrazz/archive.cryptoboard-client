//
//  WelcomeWalletViewController.swift
//  cryptoboard
//
//  Created by Jean Baptiste TERRAZZONI on 12/06/2018.
//  Copyright © 2018 terrazzoni. All rights reserved.
//

import UIKit

class WelcomeWalletViewController: UIViewController {

    lazy var nextButton = RoundedButton()
    lazy var waveBackground = WaveView()
    
    lazy var backButton: UIButton = {
        let image = UIImage(named: "left-arrow", in: Bundle.main, compatibleWith: nil)?.withRenderingMode(.alwaysTemplate)
        let button = UIButton(type: .custom)
        
        button.setImage(image, for: .normal)
        button.tintColor = UIColor.white
        button.contentMode = .scaleAspectFit
        
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        backButton.addTarget(self, action: #selector(triggerBackButton(_:)), for: .touchUpInside)
        
        view.backgroundColor = UIColor.clear
        
        nextButton.styleForHoverGradient()
        nextButton.addTarget(self, action: #selector(triggerNext(_:)), for: .touchUpInside)
        nextButton.setTitle("LETS START !", for: .normal)
        
        view.addSubviewsAutoConstraints([nextButton, waveBackground, backButton])
        
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
        
        NSLayoutConstraint.activate([
            nextButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            nextButton.bottomAnchor.constraint(equalTo: view.safeBottomAnchor, constant: -48),
            nextButton.widthAnchor.constraint(equalToConstant: 200),
            waveBackground.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            backButton.topAnchor.constraint(equalTo: view.safeTopAnchor, constant: 8)
            ])
    }
    
    @objc private func triggerBackButton(_ sender: UIImageView) {
        let parentVC = self.parent as? WelcomeViewController
        
        parentVC?.setViewController(1)
    }
    
    @objc private func triggerNext(_ sender: UIButton) {
        let parentVC = self.parent as? WelcomeViewController
        let transition = CATransition()
        transition.duration = K.Design.AnimationTime
        transition.type = kCATransitionFade
        transition.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
        
        parentVC?.view.window?.layer.add(transition, forKey: nil)
        parentVC?.dismiss(animated: false, completion: nil)
    }
    

}
