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
    
    lazy var nextButton = RoundedButton()
    lazy var waveBackground = WaveView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor.clear
        
        waveBackground.opposite = true
        
        nextButton.styleForHoverGradient()
        nextButton.addTarget(self, action: #selector(triggerNext(_:)), for: .touchUpInside)
        nextButton.setTitle("LOVE IT !", for: .normal)
        
        view.addSubviewsAutoConstraints([nextButton, waveBackground])
        
        let views = [
            "wave": waveBackground
        ]
        let constraints = [
            "H:|[wave]|",
            "V:[wave(320)]",
            ]
        
        NSLayoutConstraint.visualConstraints(views: views, visualConstraints: constraints)
        
        NSLayoutConstraint.activate([
            nextButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            nextButton.bottomAnchor.constraint(equalTo: view.safeBottomAnchor, constant: -32),
            nextButton.widthAnchor.constraint(equalToConstant: 200),
            waveBackground.centerYAnchor.constraint(equalTo: view.centerYAnchor)
            ])
    }
    
    @objc private func triggerNext(_ sender: UIButton) {
        let parentVC = self.parent as? WelcomeViewController
        
        parentVC?.setViewController(2)
    }
    
    
}
