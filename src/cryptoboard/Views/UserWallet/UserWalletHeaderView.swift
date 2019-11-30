//
//  UserWalletHeaderView.swift
//  cryptoboard
//
//  Created by Jean Baptiste TERRAZZONI on 14/06/2018.
//  Copyright © 2018 terrazzoni. All rights reserved.
//

import Foundation
import UIKit

class UserWalletHeaderView: UIView {
    
    @IBOutlet var contentView: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    
    lazy var waveView = WaveView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    // TODO Add an extension to UIView for Xib loading ? (no mone commonInit with loadNibNamed ...)
    private func commonInit() {
        Bundle.main.loadNibNamed("UserWalletHeaderView", owner: self, options: nil)
        addSubview(contentView)
        contentView.frame = self.bounds
        contentView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        contentView.backgroundColor = UIColor.clear
        
        setupViews()
    }
    
    private func setupViews() {
        waveView.fillColor = UIColor.theme.red.value
        waveView.heightMultiplier = 0.93
        waveView.translatesAutoresizingMaskIntoConstraints = false
        contentView.insertSubview(waveView, at: 0)
        
        NSLayoutConstraint.activate([
            waveView.topAnchor.constraint(equalTo: contentView.safeTopAnchor, constant: -300),
            waveView.bottomAnchor.constraint(equalTo: contentView.safeTopAnchor, constant: 64),
            waveView.leftAnchor.constraint(equalTo: contentView.leftAnchor),
            waveView.rightAnchor.constraint(equalTo: contentView.rightAnchor)
            ])
    }
    
    
}
