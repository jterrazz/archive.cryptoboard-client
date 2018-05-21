//
//  SearchController.swift
//  cryptoboard
//
//  Created by Jean Baptiste TERRAZZONI on 21/05/2018.
//  Copyright © 2018 terrazzoni. All rights reserved.
//

import Foundation
import UIKit

class SearchController: UIViewController, UIGestureRecognizerDelegate {
    
    lazy var searchBar: UITextField = {
        let input = UITextField()
        input.backgroundColor = UIColor.theme.inputBg.value
//        input.placeholder = "Search currencies"
        input.attributedPlaceholder = NSAttributedString(string: "Search currencies", attributes: [NSAttributedStringKey.foregroundColor : UIColor.theme.textIntermediate.value])
        input.translatesAutoresizingMaskIntoConstraints = false
        input.layer.cornerRadius = 22
        input.font = UIFont.systemFont(ofSize: 15, weight: UIFont.Weight.medium)
//        input.leftView =
//        input.leftViewMode = .always
        
        let backBtn = UIButton()
        backBtn.setImage(<#T##image: UIImage?##UIImage?#>, for: <#T##UIControlState#>)
        
        return input
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor.white
        view.addSubview(searchBar)
        
        NSLayoutConstraint.activate([
            searchBar.topAnchor.constraint(equalTo: view.safeTopAnchor, constant: 8),
            searchBar.leftAnchor.constraint(equalTo: view.safeLeftAnchor, constant: 0),
            searchBar.rightAnchor.constraint(equalTo: view.safeRightAnchor, constant: 0),
            searchBar.heightAnchor.constraint(equalToConstant: 44)
        ])
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.setNavigationBarHidden(true, animated: true)
        navigationController?.interactivePopGestureRecognizer?.delegate = self
    }
}
