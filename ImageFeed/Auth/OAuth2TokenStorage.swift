//
//  OAuth2TokenStorage.swift
//  ImageFeed
//
//  Created by Alibi on 05.10.2024.
//

import Foundation
import SwiftKeychainWrapper

class OAuth2TokenStorage {
    private let userDefaults = UserDefaults.standard
    
    var accessToken: String? {
        get {
            let token = KeychainWrapper.standard.string(forKey: Keys.accessToken2.rawValue)
            if token?.isEmpty == true {
                return nil
            }
            return token
        }

        set {
            KeychainWrapper.standard.set(newValue ?? "", forKey: Keys.accessToken2.rawValue)
        }
    }
}

extension OAuth2TokenStorage {
    private enum Keys: String {
        case accessToken2
    }
}
