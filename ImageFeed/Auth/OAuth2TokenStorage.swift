//
//  OAuth2TokenStorage.swift
//  ImageFeed
//
//  Created by Alibi on 05.10.2024.
//

import Foundation

class OAuth2TokenStorage {
    private let userDefaults = UserDefaults.standard
    
    var accessToken: String? {
        get {
            userDefaults.string(forKey: Keys.accessToken.rawValue)
        }

        set {
            userDefaults.set(newValue, forKey: Keys.accessToken.rawValue)
        }
    }
}

extension OAuth2TokenStorage {
    private enum Keys: String {
        case accessToken
    }
}
