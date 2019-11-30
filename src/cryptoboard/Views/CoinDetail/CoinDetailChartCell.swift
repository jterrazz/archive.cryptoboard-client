//
//  CoinDetailView.swift
//  cryptoboard
//
//  Created by Jean Baptiste TERRAZZONI on 05/06/2018.
//  Copyright © 2018 terrazzoni. All rights reserved.
//

import Foundation
import UIKit
import Charts

// TODO Add extension to String for currency formating ($ 100,42.00)
// TODO Rename all actions methods with handleXXX
// TODO Add MARK in big files

class CoinDetailChartCell: UITableViewCell {
    
    // MARK: - Views
    lazy var containerView = UIView()
    lazy var chartView = LineChartView()
    lazy var hoverInformations = CoinDetailChartDataView()
    lazy var chartSegmentedControll = RoundSegmentedControl(frame: .zero)
    lazy var headerLabel = UILabel()
    lazy var priceLabel = UILabel()
    lazy var percentLabel = UILabel()
    
    lazy var bottomArrowView: UIButton = {
        let image = UIImage(named: "arrow-filled", in: Bundle.main, compatibleWith: nil)?.withRenderingMode(.alwaysTemplate)
        let button = UIButton(type: .custom)
        
        button.setImage(image, for: .normal)
        button.tintColor = UIColor.white
        button.contentMode = .scaleAspectFit
        button.transform = button.transform.rotated(by: CGFloat.pi / 2)
        
        return button
    }()
    
    // MARK: - Constraints
    var topContainerConstraint: NSLayoutConstraint?
    var leftContainerConstraint: NSLayoutConstraint?
    var rightContainerConstraint: NSLayoutConstraint?
    var delegate: CoinDetailChartCellDelegate?
    
    var bottomArrowDirection: VerticalPosition = .down
    
    // MARK: - Data
    var currency: Currency? {
        didSet { setCurrencyData() }
    }
    var currencyLive: CurrencyLive? {
        didSet {
            DispatchQueue.main.async {
                self.setCurrencyLiveData()
            }
        }
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupViews()
    }
    
    private func setCurrencyData() {
        if (currency == nil) { return }
        
        hoverInformations.currency = self.currency
        CurrencyController().getCurrencyState(currencies: [currency!]) { (error, currencies) in
            if (currencies.count == 1) {
                self.currencyLive = currencies[0].liveData
            }
        }
    }
    
    private func setCurrencyLiveData() {
        if let liveData = self.currencyLive {
            priceLabel.text = String(liveData.variationDay)
        }
    }
    
    private func setupViews() {
        let gradient = [
            UIColor.theme.custom(hexString: "#abdcff").value.cgColor,
            UIColor.theme.custom(hexString: "#0296ff").value.cgColor,
        ]
        
        selectionStyle = .none
        backgroundColor = UIColor.theme.grayBg.value
        containerView.backgroundColor = UIColor.theme.darkBg.value
        containerView.clipsToBounds = true
        chartSegmentedControll.items = ["1H", "1D", "1M", "1Y", "ALL"]
        chartSegmentedControll.borderColor = UIColor.init(white: 1, alpha: 0.5)
        chartView.setupFilled(values: [4, 5, 1, 6, 4, 9], colors: gradient, withMargins: true)
        addSubviewAutoConstraints(containerView)
        containerView.addSubviewsAutoConstraints([chartView, hoverInformations, chartSegmentedControll, headerLabel, priceLabel, percentLabel, bottomArrowView])
        
        bottomArrowView.addTarget(self, action: #selector(handleArrowButtonPressed(_:)), for: .touchUpInside)
        
        headerLabel.text = "Live data"
        headerLabel.textColor = UIColor.theme.textOnDark.value
        headerLabel.font = UIFont.systemFont(ofSize: 14)
        priceLabel.text = "28,570"
        priceLabel.textColor = UIColor.white
        priceLabel.font = UIFont.systemFont(ofSize: 29, weight: .regular)
        percentLabel.text = "+5.8%"
        percentLabel.textColor = UIColor.theme.green.value
        percentLabel.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        
        setupConstraints()
    }
    
    private func setupConstraints() {
        topContainerConstraint = containerView.topAnchor.constraint(equalTo: topAnchor)
        rightContainerConstraint = containerView.rightAnchor.constraint(equalTo: rightAnchor)
        leftContainerConstraint = containerView.leftAnchor.constraint(equalTo: leftAnchor)
        
        let bottomControlsHeight: CGFloat = 36
        
        let views = [
            "c": containerView,
            "chart": chartView,
            "infos": hoverInformations,
            "header": headerLabel,
            "price": priceLabel,
            "percent": percentLabel,
            "arrow": bottomArrowView
        ]
        let constraints = [
            "H:|-32-[header]-32-|",
            "H:|-32-[price]-8-[percent]",
            "V:[c]|",
            "H:|-32-[infos]-32-|",
            "H:|[chart]|",
            "V:|[infos]-24-[header]-8-[price]-32-[chart]|",
            "H:[arrow(\(bottomControlsHeight))]-24-|",
            "V:[arrow(\(bottomControlsHeight))]"
        ]
        
        NSLayoutConstraint.visualConstraints(views: views, visualConstraints: constraints)
        NSLayoutConstraint.activate([
            chartSegmentedControll.centerXAnchor.constraint(equalTo: chartView.centerXAnchor),
            chartSegmentedControll.bottomAnchor.constraint(equalTo: chartView.bottomAnchor, constant: -24),
            chartSegmentedControll.heightAnchor.constraint(equalToConstant: bottomControlsHeight),
            chartSegmentedControll.widthAnchor.constraint(equalToConstant: 190),
            percentLabel.topAnchor.constraint(equalTo: priceLabel.topAnchor),
            topContainerConstraint!,
            leftContainerConstraint!,
            rightContainerConstraint!,
            bottomArrowView.centerYAnchor.constraint(equalTo: chartSegmentedControll.centerYAnchor)
            ])
    }
    
    public func setOffset(offset: CGFloat, trigger: CGFloat) {
        var changedState = false
        
        if (offset < 0) {
            topContainerConstraint?.constant = offset / 3
            return
        } else if (offset < trigger) {
            changedState = bottomArrowDirection == .up ? true : false
            
            topContainerConstraint?.constant = offset
            leftContainerConstraint?.constant = 0
            rightContainerConstraint?.constant = 0
            containerView.layer.cornerRadius = 0
        } else {
            changedState = bottomArrowDirection == .down ? true : false
            
            let diff = (offset - trigger) / 3
            let constant = diff > 8 ? 8 : diff
            
            leftContainerConstraint?.constant = constant
            rightContainerConstraint?.constant = -constant
            containerView.layer.cornerRadius = K.Design.CornerRadius
        }
        
        // TODO Reload if tableView scrolled beyond top
        if (changedState) {
            inversedMainState()
        }
        self.layoutIfNeeded()
        
    }
    
    private func inversedMainState() {
        bottomArrowDirection = bottomArrowDirection == .down ? .up : .down
        UIView.animate(withDuration: K.Design.AnimationTime) {
            self.bottomArrowView.transform = self.bottomArrowView.transform.rotated(by: CGFloat.pi)
        }
    }
    
    
}

extension CoinDetailChartCell {
    
    @objc private func handleArrowButtonPressed(_ sender: UIButton) {
        self.delegate?.didAskToChangePosition(side: bottomArrowDirection)
        inversedMainState()
    }
    
    
}

protocol CoinDetailChartCellDelegate {
    func didAskToChangePosition(side: VerticalPosition)
}
