//
//  Double.swift
//  cryptoboard
//
//  Created by Jean Baptiste TERRAZZONI on 26/05/2018.
//  Copyright © 2018 terrazzoni. All rights reserved.
//

import Foundation

extension Double {
    
    func format(f: String) -> String {
        return String(format: "%\(f)f", self)
    }
    
    
}
