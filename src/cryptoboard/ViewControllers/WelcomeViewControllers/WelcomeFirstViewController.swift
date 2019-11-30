//
//  WelcomeViewController.swift
//  cryptoboard
//
//  Created by Jean Baptiste TERRAZZONI on 12/06/2018.
//  Copyright © 2018 terrazzoni. All rights reserved.
//

import UIKit

class WelcomeFirstViewController: UIViewController {
    
    lazy var nextButton = RoundedButton()
    lazy var waveBackground = WaveView()
    lazy var stackView = UIStackView()
    lazy var titleLabel = UILabel()
    lazy var descriptionLabel = UILabel()
    lazy var topImageView = UIImageView()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupViews()
        nextButton.addTarget(self, action: #selector(triggerNext(_:)), for: .touchUpInside)
    }
    
    private func setupViews() {
        view.backgroundColor = UIColor.clear
        
        titleLabel.text = "Coinboard"
        titleLabel.textColor = UIColor.theme.textDark.value
        titleLabel.font = UIFont.systemFont(ofSize: 24, weight: .regular)
        
        view.clipsToBounds = true
        
        descriptionLabel.text = "Our app is best enjoyed if you take the time to personalize the experience."
        descriptionLabel.textColor = UIColor.theme.textIntermediate.value
        descriptionLabel.font = UIFont.systemFont(ofSize: 14)
        descriptionLabel.numberOfLines = 0
        descriptionLabel.textAlignment = .center
        
        nextButton.styleForHoverGradient()
        nextButton.setTitle("LOVE IT !", for: .normal)
        
        let cloudImage = UIImage(named: "bitcoin-cloud", in: Bundle.main, compatibleWith: nil)
        topImageView.image = cloudImage
        topImageView.contentMode = .scaleAspectFit
        
        stackView.axis = .vertical
        stackView.alignment = .center
        stackView.spacing = 8
        
        view.addSubviewsAutoConstraints([nextButton, topImageView, waveBackground, stackView])
        stackView.addArrangedSubview(titleLabel)
        stackView.addArrangedSubview(descriptionLabel)
        
        setupConstraints()
    }
    
    private func setupConstraints() {
        let views = [
            "wave": waveBackground,
            ]
        let constraints = [
            "H:|[wave]|",
            "V:[wave(320)]"
            ]
        
        NSLayoutConstraint.visualConstraints(views: views, visualConstraints: constraints)
        
        NSLayoutConstraint.activate([
            nextButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            nextButton.bottomAnchor.constraint(equalTo: view.safeBottomAnchor, constant: -48),
            nextButton.widthAnchor.constraint(equalToConstant: 200),
            waveBackground.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            stackView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            stackView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            descriptionLabel.widthAnchor.constraint(lessThanOrEqualTo: view.widthAnchor, multiplier: 0.7),
            topImageView.topAnchor.constraint(equalTo: view.safeTopAnchor, constant: 32),
            topImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            topImageView.widthAnchor.constraint(equalToConstant: 200),
            topImageView.heightAnchor.constraint(equalToConstant: 120)
            ])
    }
    
    @objc private func triggerNext(_ sender: UIButton) {
        let parentVC = self.parent as? WelcomeViewController
        
        parentVC?.setViewController(1)
    }
    

}
