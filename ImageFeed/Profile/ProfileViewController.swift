//
//  ProfileViewController.swift
//  ImageFeed
//
//  Created by Alibi on 23.09.2024.
//

import UIKit
import Kingfisher


public protocol ProfileViewControllerProtocol: AnyObject {
    var presenter: ProfileViewPresenterProtocol? { get set }
    func setNameText(_ name: String)
    func setLoginText(_ login: String)
    func setBioText(_ bio: String)
    func setAvatarImageUrl(_ url: URL)
}

final class ProfileViewController: UIViewController & ProfileViewControllerProtocol {
    var presenter: ProfileViewPresenterProtocol?
    
    private let profileImageView = UIImageView()
    private let exitButton = UIButton(type: .custom)
    private let nameLabel = UILabel()
    private let loginLabel = UILabel()
    private lazy var bioLabel = {
        let label = UILabel()
        label.text = "Hello, world!"
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 13)
        label.textColor = UIColor.white
        return label
    }()
    
    override func viewDidLoad() {
        initViews()
        presenter?.viewDidLoad()
    }
    
    func setNameText(_ name: String) {
        nameLabel.text = name
    }
    
    func setLoginText(_ login: String) {
        loginLabel.text = login
    }
    
    func setBioText(_ bio: String) {
        bioLabel.text = bio
    }
    
    func setAvatarImageUrl(_ url: URL) {
        profileImageView.kf.setImage(with: url)
    }
    
    private func initViews() {
        view.backgroundColor = .ypBlack
        let profilePhoto = UIImage(named: "profile_image")
        profileImageView.image = profilePhoto
        profileImageView.translatesAutoresizingMaskIntoConstraints = false
        profileImageView.layer.masksToBounds = true
        profileImageView.layer.cornerRadius = 35
        view.addSubview(profileImageView)
        
        var arrayOfConstraints = [
            profileImageView.heightAnchor.constraint(equalToConstant: 70),
            profileImageView.widthAnchor.constraint(equalToConstant: 70),
            profileImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            profileImageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 32)
        ]
        
        
        let exitPhoto = UIImage(named: "ic_exit")
        exitButton.setImage(exitPhoto, for: .normal)
        exitButton.translatesAutoresizingMaskIntoConstraints = false
        exitButton.addTarget(self, action: #selector(didClickExitButton), for: .touchUpInside)
        exitButton.accessibilityIdentifier = "ExitButton"
        view.addSubview(exitButton)
        
        arrayOfConstraints += [
            exitButton.heightAnchor.constraint(equalToConstant: 24),
            exitButton.widthAnchor.constraint(equalToConstant: 24),
            exitButton.centerYAnchor.constraint(equalTo: profileImageView.centerYAnchor),
            exitButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16)
        ]
        
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        nameLabel.font = UIFont.boldSystemFont(ofSize: 23)
        nameLabel.textColor = .white
        view.addSubview(nameLabel)
        
        arrayOfConstraints += [
            nameLabel.leadingAnchor.constraint(equalTo: profileImageView.leadingAnchor),
            nameLabel.topAnchor.constraint(equalTo: profileImageView.bottomAnchor, constant: 8)
        ]
        
        loginLabel.translatesAutoresizingMaskIntoConstraints = false
        loginLabel.font = UIFont.systemFont(ofSize: 13)
        loginLabel.textColor = UIColor(red: 174, green: 175, blue: 180, alpha: 1)
        view.addSubview(loginLabel)
        
        arrayOfConstraints += [
            loginLabel.leadingAnchor.constraint(equalTo: profileImageView.leadingAnchor),
            loginLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 8)
        ]
        
        view.addSubview(bioLabel)
        
        arrayOfConstraints += [
            bioLabel.leadingAnchor.constraint(equalTo: profileImageView.leadingAnchor),
            bioLabel.topAnchor.constraint(equalTo: loginLabel.bottomAnchor, constant: 8)
        ]
        
        NSLayoutConstraint.activate(arrayOfConstraints)
    }
    
    @objc private func didClickExitButton() {
        let alert = UIAlertController(title: "Пока, пока!", message: "Уверены что хотите выйти?", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Да", style: .default, handler: { action in
            ProfileLogoutService.shared.logout()
            self.switchToSplashViewController()
        }))
        alert.addAction(UIAlertAction(title: "Нет", style: .cancel))
        
        present(alert, animated: true)
    }
    
    private func switchToSplashViewController() {
        guard let window = UIApplication.shared.windows.first else {
            assertionFailure("Invalid window configuration")
            return
        }
        
        let splashViewController = SplashViewController()
        window.rootViewController = splashViewController
    }
}
