//
//  ProfileViewControllerSpy.swift
//  ImageFeedTests
//
//  Created by Alibi on 27.10.2024.
//

import ImageFeed
import Foundation

class ProfileViewControllerSpy: ProfileViewControllerProtocol {
    var nameText: String?
    var loginText: String?
    var bioText: String?
    var avatarURL: URL?
    
    var presenter: ImageFeed.ProfileViewPresenterProtocol?
    
    func setNameText(_ name: String) {
        nameText = name
    }
    
    func setLoginText(_ login: String) {
        loginText = login
    }
    
    func setBioText(_ bio: String) {
        bioText = bio
    }
    
    func setAvatarImageUrl(_ url: URL) {
        avatarURL = url
    }
}
