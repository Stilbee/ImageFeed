//
//  ProfileServiceSpy.swift
//  ImageFeedTests
//
//  Created by Alibi on 27.10.2024.
//

import ImageFeed
import Foundation

class ProfileServiceSpy: ProfileServiceProtocol {
    var profile: ImageFeed.Profile?
    
    func fetchProfile(_ accessToken: String, completeHandler: @escaping (Result<ImageFeed.ProfileResult, any Error>) -> Void) {
        
    }
}
