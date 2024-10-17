//
//  Photo.swift
//  ImageFeed
//
//  Created by Alibi on 17.10.2024.
//

import Foundation

struct PhotoResult: Codable {
    let id: String
    let width: Int
    let height: Int
    let createdAt: Date
    let likedByUser: Bool
    let description: String?
    let urls: UrlsResult
    
    private enum CodingKeys: String, CodingKey {
        case id = "id"
        case width = "width"
        case height = "height"
        case createdAt = "created_at"
        case likedByUser = "liked_by_user"
        case description = "description"
        case urls = "urls"
    }
}

struct UrlsResult: Codable {
    let raw: String
    let full: String
    let regular: String
    let small: String
    let smallS3: String
    let thumb: String
    
    private enum CodingKeys: String, CodingKey {
        case raw = "raw"
        case full = "full"
        case regular = "regular"
        case small = "small"
        case smallS3 = "small_s3"
        case thumb = "thumb"
    }
}
