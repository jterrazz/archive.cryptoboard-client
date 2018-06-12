//
//  SearchBar.swift
//  cryptoboard
//
//  Created by Jean Baptiste TERRAZZONI on 11/06/2018.
//  Copyright © 2018 terrazzoni. All rights reserved.
//

import UIKit

extension UITextField {
    
    enum PaddingSide {
        case left(CGFloat)
        case right(CGFloat)
        case both(CGFloat)
    }
    
    func addPadding(_ padding: PaddingSide) {
        
        self.leftViewMode = .always
        self.layer.masksToBounds = true
        
        switch padding {
            
        case .left(let spacing):
            let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: spacing, height: self.frame.height))
            self.leftView = paddingView
            self.rightViewMode = .always
            
        case .right(let spacing):
            let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: spacing, height: self.frame.height))
            self.rightView = paddingView
            self.rightViewMode = .always
            
        case .both(let spacing):
            let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: spacing, height: self.frame.height))
            // left
            self.leftView = paddingView
            self.leftViewMode = .always
            // right
            self.rightView = paddingView
            self.rightViewMode = .always
        }
    }
    
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
