//
//  ProfileViewController.swift
//  ImageFeed
//
//  Created by Alibi on 23.09.2024.
//

import UIKit

class ProfileViewController: UIViewController {

    private let profileImageView = UIImageView()
    private let exitButton = UIButton(type: .custom)
    private let nameLabel = UILabel()
    private let loginLabel = UILabel()
    private let textLabel = UILabel()
    
    override func viewDidLoad() {
        let profilePhoto = UIImage(named: "profile_image")
        profileImageView.image = profilePhoto
        profileImageView.translatesAutoresizingMaskIntoConstraints = false
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
        view.addSubview(exitButton)
        
        arrayOfConstraints += [
            exitButton.heightAnchor.constraint(equalToConstant: 24),
            exitButton.widthAnchor.constraint(equalToConstant: 24),
            exitButton.centerYAnchor.constraint(equalTo: profileImageView.centerYAnchor),
            exitButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16)
        ]
        
        
        nameLabel.text = "Екатерина Новикова"
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        nameLabel.font = UIFont.boldSystemFont(ofSize: 23)
        nameLabel.textColor = .white
        view.addSubview(nameLabel)
        
        arrayOfConstraints += [
            nameLabel.leadingAnchor.constraint(equalTo: profileImageView.leadingAnchor),
            nameLabel.topAnchor.constraint(equalTo: profileImageView.bottomAnchor, constant: 8)
        ]
        
    
        loginLabel.text = "@ekaterina_nov"
        loginLabel.translatesAutoresizingMaskIntoConstraints = false
        loginLabel.font = UIFont.systemFont(ofSize: 13)
        loginLabel.textColor = UIColor(red: 174, green: 175, blue: 180, alpha: 1)
        view.addSubview(loginLabel)
        
        arrayOfConstraints += [
            loginLabel.leadingAnchor.constraint(equalTo: profileImageView.leadingAnchor),
            loginLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 8)
        ]
        
        
        textLabel.text = "Hello, world!"
        textLabel.translatesAutoresizingMaskIntoConstraints = false
        textLabel.font = UIFont.systemFont(ofSize: 13)
        textLabel.textColor = UIColor.white
        view.addSubview(textLabel)
        
        arrayOfConstraints += [
            textLabel.leadingAnchor.constraint(equalTo: profileImageView.leadingAnchor),
            textLabel.topAnchor.constraint(equalTo: loginLabel.bottomAnchor, constant: 8)
        ]
        
        NSLayoutConstraint.activate(arrayOfConstraints)
    }
}
