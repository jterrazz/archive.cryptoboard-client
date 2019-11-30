//
//  RoundSegmentedControl.swift
//  cryptoboard
//
//  Created by Jean Baptiste TERRAZZONI on 06/06/2018.
//  Copyright © 2018 terrazzoni. All rights reserved.
//

import UIKit
import AudioToolbox

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
    private var draggedFromSelectedView: Bool = false
    
    override var bounds: CGRect {
        didSet {
            // Avoid many calls compared to layoutSubviews()
            boundsChanged()
        }
    }
    
    // Data
    var items: [String] = ["0", "1", "2"] { didSet { setupLabels() }}
    var selectedIndex: Int = 0 { didSet { didSelectIndex(index: selectedIndex) }}
    
    // Style
    var selectedLabelColor: UIColor = UIColor.black { didSet { setColors() }}
    var unselectedLabelColor: UIColor = UIColor.white { didSet { setColors() }}
    var selectedColor: UIColor = UIColor.white { didSet { setColors() }}
    var borderColor: UIColor = UIColor.white { didSet { setColors() }}
    var font: UIFont = UIFont.systemFont(ofSize: 14) { didSet { setFont() }}
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    private func commonInit() {
        clipsToBounds = true
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
        containerView.addGestureRecognizer(tapGesture)
        
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(handlePan(_:)))
        containerView.addGestureRecognizer(panGesture)
    }
    
    private func setupLabels() {
        for label in labels {
            label.removeFromSuperview()
        }
        
        labels.removeAll(keepingCapacity: true)
        
        for item in items {
            let label = UILabel(frame: .zero)
            label.text = item
            label.backgroundColor = UIColor.clear
            label.textAlignment = .center
            label.font = UIFont.systemFont(ofSize: 14)
            label.textColor = UIColor.white
            label.isUserInteractionEnabled = false
            
            // TODO create color if index selected ?
            
            containerView.addArrangedSubview(label)
            labels.append(label)
        }
        
        setColors()
    }
    
    @objc private func handleButtonPressed(_ sender: UITapGestureRecognizer) {
        if let index = getIndexForTouchLocation(location: sender.location(in: self)) {
            AudioServicesPlaySystemSound(1519)
            selectedIndex = index
        }
    }
    
    @objc private func handlePan(_ sender: UIPanGestureRecognizer) {
        let translation = sender.translation(in: containerView)
        
        if (sender.state == .began) {
            let location = sender.location(in: containerView)
            draggedFromSelectedView = selectedView.frame.contains(location) ? true : false
        }
        switch sender.state {
        case .began, .changed:
            if (!draggedFromSelectedView) {
                return
            }
            
            let newXPosition = selectedView.center.x + translation.x
            let distanceToCenter = selectedView.frame.width / 2
            let leftLimit = 0 + distanceToCenter
            let rightLimit = containerView.frame.width - distanceToCenter
            
            if (newXPosition > leftLimit && newXPosition < rightLimit) {
                selectedView.center = CGPoint.init(x: newXPosition, y: selectedView.center.y)
                sender.setTranslation(CGPoint(x: 0, y: 0), in: containerView)
            }
        case .ended:
            if let index = getIndexForTouchLocation(location: selectedView.center) {
                selectedIndex = index
                AudioServicesPlaySystemSound(1519)
            }
        default:
            break
        }
    }
    
    private func getIndexForTouchLocation(location: CGPoint) -> Int? {
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
        
        return calculatedIndex
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
    
    private func didSelectIndex(index: Int) {
        for label in labels {
            label.textColor = unselectedLabelColor
        }
        
        let selectedLabel = labels[selectedIndex]
        selectedLabel.textColor = selectedLabelColor
        
        UIView.animate(withDuration: K.Design.AnimationTime, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.4, options: [], animations: {
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
