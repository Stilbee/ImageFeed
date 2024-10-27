//
//  ProfileViewPresenter.swift
//  ImageFeed
//
//  Created by Alibi on 27.10.2024.
//

import Foundation

public protocol ProfileViewPresenterProtocol {
    var view: ProfileViewControllerProtocol? { get set }
    func viewDidLoad()
}

final class ProfileViewPresenter: ProfileViewPresenterProtocol {
    weak var view: ProfileViewControllerProtocol?
    let profileService: ProfileServiceProtocol
    let profileImageService: ProfileImageServiceProtocol
    
    init(profileService: ProfileServiceProtocol = ProfileService.shared, 
         profileImageService: ProfileImageServiceProtocol = ProfileImageService.shared) {
        self.profileService = profileService
        self.profileImageService = profileImageService
    }
    
    private var profileImageServiceObserver: NSObjectProtocol?
    
    func viewDidLoad() {
        if let profile = profileService.profile {
            view?.setNameText(profile.name)
            view?.setLoginText(profile.loginName)
            view?.setBioText(profile.bio ?? "")
        }
        
        profileImageServiceObserver = NotificationCenter.default
            .addObserver(
                forName: ProfileImageService.didChangeNotification,
                object: nil,
                queue: .main
            ) { [weak self] _ in
                guard let self = self else { return }
                self.updateAvatar()
            }
        updateAvatar()
    }
    
    private func updateAvatar() {
        guard let urlString = profileImageService.avatarURL,
            let url = URL(string: urlString) else {
            return
        }
        view?.setAvatarImageUrl(url)
    }
}
