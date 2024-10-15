//
//  UserResult.swift
//  ImageFeed
//
//  Created by Alibi on 12.10.2024.
//

import Foundation

class UserResult: Codable {
    let username: String
    let firstName: String
    let lastName: String
    let bio: String?
    let profileImage: [String: String]?

    private enum CodingKeys: String, CodingKey {
        case username = "username"
        case firstName = "first_name"
        case lastName = "last_name"
        case bio = "bio"
        case profileImage = "profile_image"
    }
}

