//
//  SplashViewController.swift
//  ImageFeed
//
//  Created by Alibi on 05.10.2024.
//

import UIKit

final class SplashViewController: UIViewController {
    private final let showAuthenticationScreenSegueIdentifier = "SplashAuthSegue"
    
    private let storage = OAuth2TokenStorage()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initViews()
    }
    
    private func initViews() {
        let logoImageView = UIImageView();
        logoImageView.image = UIImage(named: "LaunchScreenLogo")
        view.addSubview(logoImageView)
        
        NSLayoutConstraint.activate([
            logoImageView.heightAnchor.constraint(equalToConstant: 77),
            logoImageView.widthAnchor.constraint(equalToConstant: 75),
            logoImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            logoImageView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            
        ])
        
        view.backgroundColor = .ypBlack
    }
    

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if let token = storage.accessToken {
            fetchProfile(token)
        } else {
            let authNavController = createAuthNavController()
            authNavController.modalPresentationStyle = .fullScreen
            present(authNavController, animated: true)
        }
    }
   
    private func createAuthNavController() -> UINavigationController {
        let authNavController = UIStoryboard(name: "Main", bundle: .main)
            .instantiateViewController(withIdentifier: "AuthNavController") as! UINavigationController
        let authViewController = authNavController.viewControllers[0] as! AuthViewController
        authViewController.delegate = self
        return authNavController
    }
    
    private func switchToTabBarController() {
        guard let window = UIApplication.shared.windows.first else {
            assertionFailure("Invalid window configuration")
            return
        }
        
        let tabBarController = UIStoryboard(name: "Main", bundle: .main)
            .instantiateViewController(withIdentifier: "TabBarViewController")
           
        window.rootViewController = tabBarController
    }
    
    private func fetchProfile(_ token: String) {
        UIBlockingProgressHUD.show()
        ProfileService.shared.fetchProfile(token) { result in
            UIBlockingProgressHUD.dismiss()
            switch (result) {
            case .success(let profile):
                ProfileImageService.shared.fetchProfileImageURL(username: profile.username) {_ in}
                self.switchToTabBarController()
                break
            case .failure(_):
                break
            }
        }
    }
}

extension SplashViewController: AuthViewControllerDelegate {
    func didAuthenticate(_ vc: AuthViewController) {
        vc.dismiss(animated: true)
    }
}
