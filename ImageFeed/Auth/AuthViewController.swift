//
//  AuthViewController.swift
//  ImageFeed
//
//  Created by Alibi on 03.10.2024.
//

import Foundation
import UIKit

protocol AuthViewControllerDelegate: AnyObject {
    func didAuthenticate(_ vc: AuthViewController)
}

final class AuthViewController: UIViewController {
    private let storage = OAuth2TokenStorage()
    private let oauth2Service = OAuth2Service.shared
    
    var delegate: AuthViewControllerDelegate? = nil
    
    override func viewDidLoad() {
        configureBackButton()
    }
    
    private func configureBackButton() {
        navigationController?.navigationBar.backIndicatorImage = UIImage(named: "nav_back_button") // 1
        navigationController?.navigationBar.backIndicatorTransitionMaskImage = UIImage(named: "nav_back_button") // 2
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil) // 3
        navigationItem.backBarButtonItem?.tintColor = UIColor(named: "YP Black") // 4
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ShowWebView" {
            guard let viewController = segue.destination as? WebViewViewController
            else {
                assertionFailure("Invalid segue destination")
                return
            }

            viewController.delegate = self
        } else {
            super.prepare(for: segue, sender: sender)
        }
    }
}

extension AuthViewController: WebViewViewControllerDelegate {
    func webViewViewController(_ vc: WebViewViewController, didAuthenticateWithCode code: String) {
        vc.dismiss(animated: true)
        
        oauth2Service.fetchOAuthToken(code: code) { response in
            guard let accessToken = response?.accessToken else {
                return
            }
            self.storage.accessToken = accessToken
            self.delegate?.didAuthenticate(self)
        }
    }
    
    func webViewViewControllerDidCancel(_ vc: WebViewViewController) {
        dismiss(animated: true)
    }
}