//
//  FollowedCoinsPopUpViewController.swift
//  cryptoboard
//
//  Created by Jean Baptiste TERRAZZONI on 13/06/2018.
//  Copyright © 2018 terrazzoni. All rights reserved.
//

import UIKit

class FollowedCoinsPopUpViewController: PopUpViewController {
    
    lazy var stackView = UIStackView()
    lazy var followCoinView = FollowCoinView()
    lazy var confirmButton = RoundedButton()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadData()
        setupViews()
    }
    
    private func loadData() {
        CurrencyController().getList(limit: 999999) { (error, currencies) in
            if (error != nil) {
                self.followCoinView.networkError = true
            } else {
                self.followCoinView.networkError = false
                self.followCoinView.coinList = currencies
            }
        }
    }
    
    private func setupViews() {
        
        followCoinView.delegate = self
        view.addSubviewAutoConstraints(stackView)
        stackView.addArrangedSubview(followCoinView)
        stackView.addArrangedSubview(confirmButton)
        stackView.axis = .vertical
        stackView.alignment = .center
        stackView.spacing = 16
        followCoinView.backgroundColor = UIColor.theme.bg.value
        followCoinView.layer.cornerRadius = K.Design.CornerRadius
        confirmButton.setTitle("Confirm", for: .normal)
        confirmButton.styleForHoverGradient()
        confirmButton.backgroundColor = UIColor.theme.blueClear.withAlpha(0.7)
        
        NSLayoutConstraint.activate([
            stackView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 16),
            stackView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -16),
            stackView.topAnchor.constraint(equalTo: view.safeTopAnchor, constant: 64),
            stackView.bottomAnchor.constraint(equalTo: view.safeBottomAnchor, constant: -64),
            followCoinView.widthAnchor.constraint(equalTo: stackView.widthAnchor, multiplier: 1),
            confirmButton.widthAnchor.constraint(equalToConstant: 200)
            ])
    }
    
    @objc func handleConfirmButton(_ sender: UIButton) {
        do {
            try followCoinView.saveFollowedCurrencies()
        } catch {
            // TODO Show Pop up error and maybe dont go next
        }
    }
    
    
}

// Tranform Protocol to maybe class ?
extension FollowedCoinsPopUpViewController: FollowCoinViewDelegate {
    
    func askedToReloadData() {
        loadData()
    }
    
    
    
    
}
