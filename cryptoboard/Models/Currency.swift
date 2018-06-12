//
//  Currency.swift
//  cryptoboard
//
//  Created by Jean Baptiste TERRAZZONI on 22/05/2018.
//  Copyright © 2018 terrazzoni. All rights reserved.
//

import Foundation

class Currency: Codable, CustomStringConvertible {
    
    var id: UInt
    var name: String
    var diminutive: String
    var imageName: String?
    var liveData: CurrencyLive?
    var historyPrice: [CurrencyPrice]?
    var createdAt: Date
    
    var description: String {
        return "ID: \(id), name: \(name), diminutive: \(diminutive), imageName: \(String(describing: imageName)), liveData: \(String(describing: liveData))"
    }
    
    static func convertToSymbolArray(arr: [Currency]) -> [String] {
        var ret = [String]()
        
        arr.forEach { (currency) in
            ret.append(currency.diminutive)
        }
        
        return ret
    }
    
    init(id: UInt, name: String, diminutive: String, imageName: String?) {
        self.id = id
        self.name = name
        self.diminutive = diminutive
        self.imageName = imageName != nil ? imageName : "\(diminutive)_icon"
        self.createdAt = Date()
    }
    
    static func filterList(_ searched: String?, coinList: [Currency]) -> [Currency]? {
        var results = [Currency]()
        
        if let searched = searched?.lowercased() {
            results = coinList.filter({ (currency) -> Bool in
                let nameMatch = currency.name.lowercased().range(of: searched)
                let symbolMatch = currency.diminutive.lowercased().range(of: searched)
                
                let match = (nameMatch != nil || symbolMatch != nil) ? true : false
                
                return match
            })
            return results.count > 0 ? results : nil
        }
        
        return nil
    }
    
    
}
