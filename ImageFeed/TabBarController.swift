//
//  TabBarController.swift
//  ImageFeed
//
//  Created by Alibi on 15.10.2024.
//

import Foundation
import UIKit
 
final class TabBarController: UITabBarController {
    override func awakeFromNib() {
        super.awakeFromNib()
        let storyboard = UIStoryboard(name: "Main", bundle: .main)
        
        let imageListViewPresenter = ImageListViewPresenter()
        let imagesListViewController = storyboard.instantiateViewController(
            withIdentifier: "ImagesListViewController"
        ) as! ImagesListViewController
        imageListViewPresenter.view = imagesListViewController
        imagesListViewController.presenter = imageListViewPresenter
        
        let profileViewPresenter = ProfileViewPresenter()
        
        let profileViewController = ProfileViewController()
        profileViewPresenter.view = profileViewController
        profileViewController.presenter = profileViewPresenter
        
        profileViewController.tabBarItem = UITabBarItem(
                       title: "",
                       image: UIImage(named: "tab_profile_active"),
                       selectedImage: nil
                   )
        
        self.viewControllers = [imagesListViewController, profileViewController]
    }
}
