//
//  ProfileLogoutService.swift
//  ImageFeed
//
//  Created by Alibi on 17.10.2024.
//

import Foundation
import WebKit

final class ProfileLogoutService {
    static let shared = ProfileLogoutService()
  
    private init() { }

    func logout() {
        cleanCookies()
        cleanAccessToken()
        cleanProfileInfo()
    }

    private func cleanCookies() {
        // Очищаем все куки из хранилища
        HTTPCookieStorage.shared.removeCookies(since: Date.distantPast)
        // Запрашиваем все данные из локального хранилища
        WKWebsiteDataStore.default().fetchDataRecords(ofTypes: WKWebsiteDataStore.allWebsiteDataTypes()) { records in
                // Массив полученных записей удаляем из хранилища
                records.forEach { record in
                    WKWebsiteDataStore.default().removeData(ofTypes: record.dataTypes, for: [record], completionHandler: {})
                }
            }
    }
    
    private func cleanAccessToken() {
        OAuth2TokenStorage().accessToken = nil
    }
    
    private func cleanProfileInfo() {
        ProfileService.shared.cleanProfile()
    }
}
    
