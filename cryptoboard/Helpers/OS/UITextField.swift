//
//  SearchBar.swift
//  cryptoboard
//
//  Created by Jean Baptiste TERRAZZONI on 11/06/2018.
//  Copyright © 2018 terrazzoni. All rights reserved.
//

import UIKit

extension UITextField {
    
    class func searchBar(cornerRadius: CGFloat, theme: ThemeStatus, leftImage: UIImage?, leftImageFrame: CGRect?) -> UITextField {
        let textField = UITextField(frame: .zero)
        
        textField.layer.cornerRadius = cornerRadius
        textField.font = UIFont.systemFont(ofSize: 14, weight: UIFont.Weight.medium)
        textField.autocorrectionType = .no
        textField.attributedPlaceholder = NSAttributedString(string: "Search any coins", attributes: [NSAttributedStringKey.font: UIFont.systemFont(ofSize: 14, weight: UIFont.Weight.medium)])
        textField.textColor = UIColor.theme.textDark.value
        
        if (theme == .clear) {
            textField.backgroundColor = UIColor.theme.inputBg.value
        } else {
            textField.backgroundColor = UIColor.white
        }
        
        if (leftImage != nil && leftImageFrame != nil) {
            let backView = UIImageView.init(frame: leftImageFrame!)
            backView.image = leftImage?.withRenderingMode(UIImageRenderingMode.alwaysTemplate)
            backView.contentMode = .scaleAspectFit
            backView.tintColor = UIColor.theme.textIntermediate.value
            backView.isUserInteractionEnabled = true
            
            textField.leftView = backView
            textField.leftViewMode = .always
        }
        
        return textField
    }
    
    
}
