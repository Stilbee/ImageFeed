//
//  Profile.swift
//  ImageFeed
//
//  Created by Alibi on 12.10.2024.
//

import Foundation


struct ProfileResponseBody: Codable {
    let username: String
    let firstName: String
    let lastName: String
    let bio: String?

    private enum CodingKeys: String, CodingKey {
        case username = "username"
        case firstName = "first_name"
        case lastName = "last_name"
        case bio = "bio"
    }
}