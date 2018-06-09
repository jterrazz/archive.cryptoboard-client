//
//  RoundSegmentedControl.swift
//  cryptoboard
//
//  Created by Jean Baptiste TERRAZZONI on 06/06/2018.
//  Copyright © 2018 terrazzoni. All rights reserved.
//

import UIKit

class RoundSegmentedControl: UISegmentedControl {

    lazy var containerView: UIStackView = {
        let view = UIStackView()
        view.axis = .horizontal
        view.alignment = UIStackViewAlignment.fill
        view.distribution = UIStackViewDistribution.fillEqually
        return view
    }()
    
    private var labels = [UILabel]()
    private var selectedView = UIView()
    
    override var bounds: CGRect {
        didSet {
            // Avoid many calls compared to layoutSubviews()
            boundsChanged()
        }
    }
    
    // Data
    var items: [String] = ["0", "1", "222"]
    var selectedIndex: Int = 0 {
        didSet {
            
        }
    }
    
    // Style
    var selectedLabelColor: UIColor = UIColor.black {didSet {setColors()}}
    var unselectedLabelColor: UIColor = UIColor.white {didSet {setColors()}}
    var selectedColor: UIColor = UIColor.white {didSet {setColors()}}
    var borderColor: UIColor = UIColor.white {didSet {setColors()}}
    var font: UIFont = UIFont.systemFont(ofSize: 14) {didSet {setFont()}}
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    private func commonInit() {
        backgroundColor = UIColor.clear
        isUserInteractionEnabled = true
        
        addSubviewAutoConstraints(containerView)
        setupLabels()
        insertSubview(selectedView, at: 0)
        
        NSLayoutConstraint.activate([
            containerView.leftAnchor.constraint(equalTo: self.leftAnchor),
            containerView.rightAnchor.constraint(equalTo: self.rightAnchor),
            containerView.topAnchor.constraint(equalTo: self.topAnchor),
            containerView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
        ])
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleButtonPressed(_:)))
        tapGesture.numberOfTouchesRequired = 1
        containerView.isUserInteractionEnabled = true
        containerView.addGestureRecognizer(tapGesture)
    }
    
    private func setupLabels() {
        for label in labels {
            containerView.removeArrangedSubview(label)
        }
        
        labels.removeAll(keepingCapacity: true)
        
        for item in items {
            let label = UILabel(frame: .zero)
            label.text = item
            label.backgroundColor = UIColor.clear
            label.textAlignment = .center
            label.font = UIFont.systemFont(ofSize: 14)
            label.textColor = UIColor.white
            
            // TODO create color if index selected ?
            
            containerView.addArrangedSubview(label)
            labels.append(label)
        }
        
        setColors()
    }
    
    @objc private func handleButtonPressed(_ sender: UITapGestureRecognizer) {
        print("okokokok")
    }
    
    override func beginTracking(_ touch: UITouch, with event: UIEvent?) -> Bool {
        let location = touch.location(in: self)
        print(location)
        
        var calculatedIndex: Int?
        for (index, label) in labels.enumerated() {
            if (label.frame.contains(location)) {
                calculatedIndex = index
            }
        }
        
        if (calculatedIndex != nil) {
            selectedIndex = calculatedIndex!
            sendActions(for: .valueChanged)
        }
        
        return false
    }
    
    private func boundsChanged() {
        layer.cornerRadius = frame.height / 2
        layer.borderColor = borderColor.cgColor
        layer.borderWidth = 2
        
        var selectedFrame = self.bounds
        selectedFrame.size.width = self.bounds.width / CGFloat(items.count)
        
        selectedView.frame = selectedFrame
        selectedView.backgroundColor = selectedColor
        selectedView.layer.cornerRadius = selectedView.frame.height / 2
    }
    
    private func setSelectedIndex() {
        for label in labels {
            label.textColor = unselectedLabelColor
        }
        
        let selectedLabel = labels[selectedIndex]
        selectedLabel.textColor = selectedLabelColor
        
        UIView.animate(withDuration: K.Design.AnimationTime, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.8, options: [], animations: {
            self.selectedView.frame = selectedLabel.frame
        }, completion: nil)
    }
    
    private func setColors() {
        for label in labels {
            label.textColor = unselectedLabelColor
        }
        
        if (labels.count > selectedIndex) {
            labels[selectedIndex].textColor = selectedLabelColor
        }
        
        layer.borderColor = borderColor.cgColor
        selectedView.backgroundColor = selectedColor
    }
    
    private func setFont() {
        for label in labels {
            label.font = font
        }
    }
    

}
