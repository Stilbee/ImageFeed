//
//  ProfileImageServiceProtocolSpy.swift
//  ImageFeedTests
//
//  Created by Alibi on 27.10.2024.
//

import ImageFeed
import Foundation

class ProfileImageServiceSpy: ProfileImageServiceProtocol {
    var avatarURL: String?
    
    func fetchProfileImageURL(username: String, _ completion: @escaping (Result<String, any Error>) -> Void) {
        
    }
}
