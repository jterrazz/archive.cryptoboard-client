//
//  UserSettingsController.swift
//  cryptoboard
//
//  Created by Jean Baptiste TERRAZZONI on 28/05/2018.
//  Copyright © 2018 terrazzoni. All rights reserved.
//

import Foundation

class UserSettingsController {
    
    private let SETTINGS_KEY = "user-settings-key"
    private let userDefaults = UserDefaults.standard
    private let encoder = JSONEncoder()
    private let decoder = JSONDecoder()
    
    func get() -> UserSettings? {
        var settings: UserSettings?
        
        if let data = userDefaults.data(forKey: SETTINGS_KEY) {
            settings = try? decoder.decode(UserSettings.self, from: data)
        }
        
        return settings
    }
    
    func set(_ settings: UserSettings) throws {
        let encoded = try encoder.encode(settings)
        
        userDefaults.set(encoded, forKey: SETTINGS_KEY)
    }
    
    func reset() {
        userDefaults.removeObject(forKey: SETTINGS_KEY)
    }
    
    func update(ft: (UserSettings) -> Void) throws {
        if let settings = get() {
            ft(settings)
            
            try self.set(settings)
        } else {
            throw StorageError.getError
        }
    }
    
    func isFollowingCurrency(_ symbol: String) -> Bool {
        
        if let followedSymbols = get()?.followedCurrencies {
            return (followedSymbols.index(of: symbol) != nil) ? true : false
        }
        
        return false
    }
    
    
}
