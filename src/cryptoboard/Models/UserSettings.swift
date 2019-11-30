//
//  Settings.swift
//  cryptoboard
//
//  Created by Jean Baptiste TERRAZZONI on 28/05/2018.
//  Copyright © 2018 terrazzoni. All rights reserved.
//

import Foundation

class UserSettings: Codable {
    
    public private(set) var localCurrency: LocalCurrency
    public private(set) var followedCurrencies = [String]() // Store the symbol
    
    init(localCurrency: LocalCurrency) {
        self.localCurrency = localCurrency
    }
    
    func changeLocalCurrency(_ currency: LocalCurrency) {
        self.localCurrency = currency
    }
    
    func followCurrency(_ symbol: String) {
        let i = followedCurrencies.index(of: symbol)
        
        if (i == nil) {
            followedCurrencies.append(symbol)
        }
    }
    
    func unfollowCurrency(_ symbol: String) {
        if let i = followedCurrencies.index(of: symbol) {
            followedCurrencies.remove(at: i)
        }
    }
    
    func moveFollowedCurrency(_ symbol: String, toIndex: Int) {
        if let i = followedCurrencies.index(of: symbol) {
            followedCurrencies.rearrange(from: i, to: toIndex)
        }
    }
    
    func emptyFollowedCurrency() {
        followedCurrencies.removeAll(keepingCapacity: true)
    }
    
    
}
