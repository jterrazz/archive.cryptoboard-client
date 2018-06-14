//
//  Currency.swift
//  cryptoboard
//
//  Created by Jean Baptiste TERRAZZONI on 22/05/2018.
//  Copyright © 2018 terrazzoni. All rights reserved.
//

// TODO Better currency list getter and parser for lists (too long)

import Foundation

class Currency: Codable, CustomStringConvertible {
    
    var id: UInt
    var name: String
    var diminutive: String
    var imageName: String?
    var imageUrl: String?
    
    var completeImageUrl: String? {
        get {
            return imageUrl == nil ? nil : K.APIServer.cdn + imageUrl!
        }
    }
    
    var liveData: CurrencyLive?
    var historyPrice: [CurrencyPrice]?
    var createdAt: Date
    var isFollowing: Bool {
        get {
            return UserSettingsController().isFollowingCurrency(self.diminutive)
        }
    }
    
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
    
    
}

extension Array where Element:Currency {
    
    func filterList(_ searched: String?) -> [Currency]? {
        var results = [Currency]()
        
        if let searched = searched?.lowercased() {
            results = self.filter({ (currency) -> Bool in
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
