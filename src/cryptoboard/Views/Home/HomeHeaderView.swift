//
//  HomeHeaderView.swift
//  cryptoboard
//
//  Created by Jean Baptiste TERRAZZONI on 05/06/2018.
//  Copyright © 2018 terrazzoni. All rights reserved.
//

import UIKit

class HomeHeaderView: UIView {

    @IBOutlet var contentView: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var leftBorder: UIView!
    @IBOutlet weak var rightButton: UIButton!
    
    var delegate: HomeHeaderViewDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    private func commonInit() {
        Bundle.main.loadNibNamed("HomeHeaderView", owner: self, options: nil)
        addSubview(contentView)
        contentView.frame = self.bounds
        contentView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        
        rightButton.addTarget(self, action: #selector(handleButtonClick(_:)), for: .touchUpInside)
        
        setupViews()
    }
    
    private func setupViews() {
        rightButton.setTitle(nil, for: .normal)
        rightButton.titleLabel?.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        leftBorder.layer.cornerRadius = 2
        rightButton.setTitleColor(UIColor.theme.textDark.value, for: .normal)
        titleLabel.textColor = UIColor.theme.textDark.value
        titleLabel.font = UIFont.systemFont(ofSize: 14, weight: .semibold)
    }
    
    public func setup(title: String, borderColor: UIColor = UIColor.theme.textDark.value, rightText: String?) {
        titleLabel.text = title
        leftBorder.backgroundColor = borderColor
        rightButton.setTitle(rightText, for: .normal)
    }
    
    @objc private func handleButtonClick(_ sender: UIButton) {
        delegate?.didSelectButton()
    }
    
    
}

protocol HomeHeaderViewDelegate {
    
    func didSelectButton()
    
    
}
