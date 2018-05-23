//
//  Constants.swift
//  cryptoboard
//
//  Created by Jean Baptiste TERRAZZONI on 21/05/2018.
//  Copyright © 2018 terrazzoni. All rights reserved.
//

import Foundation
import UIKit

struct K {
    struct Design {
        static let CornerRadius: CGFloat = 10
    }
    
    static let Currencies: [Currency] = [
        Currency(id: 0, name: "Bitcoin", diminutive: "BTC", imageName: nil),
        Currency(id: 1, name: "Ethereum", diminutive: "ETH", imageName: nil),
        Currency(id: 2, name: "Bitcoin cash", diminutive: "BCH", imageName: nil),
        Currency(id: 3, name: "EOS", diminutive: "EOS", imageName: nil),
        Currency(id: 4, name: "LOL", diminutive: "LOL", imageName: nil),
    ]
}
