//
//  OAuthTokenResponseBody.swift
//  ImageFeed
//
//  Created by Alibi on 05.10.2024.
//

import Foundation


struct OAuthTokenResponseBody: Codable {
    let accessToken: String

    private enum CodingKeys: String, CodingKey {
        case accessToken = "access_token"
    }
}
