//
//  AuthViewController.swift
//  ImageFeed
//
//  Created by Alibi on 03.10.2024.
//

import Foundation
import UIKit
import ProgressHUD

protocol AuthViewControllerDelegate: AnyObject {
    func didAuthenticate(_ vc: AuthViewController)
}

final class AuthViewController: UIViewController {
    private let storage = OAuth2TokenStorage()
    private let oauth2Service = OAuth2Service.shared
    
    weak var delegate: AuthViewControllerDelegate? = nil
    
    override func viewDidLoad() {
        configureBackButton()
    }
    
    private func configureBackButton() {
        navigationController?.navigationBar.backIndicatorImage = UIImage(named: "nav_back_button")
        navigationController?.navigationBar.backIndicatorTransitionMaskImage = UIImage(named: "nav_back_button")
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        navigationItem.backBarButtonItem?.tintColor = UIColor(named: "YP Black")
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
    
    private func showErrorAlert() {
        let alert = UIAlertController(title: "Что-то пошло не так(", message: "Не удалось войти в систему", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .cancel))
        present(alert, animated: true)
    }
}

extension AuthViewController: WebViewViewControllerDelegate {
    func webViewViewController(_ vc: WebViewViewController, didAuthenticateWithCode code: String) {
        UIBlockingProgressHUD.show()
        oauth2Service.fetchOAuthToken(code: code) { result in
            UIBlockingProgressHUD.dismiss()
            switch (result) {
            case .success(let accessToken):
                self.storage.accessToken = accessToken
                self.delegate?.didAuthenticate(self)
                vc.dismiss(animated: true)
            case .failure(let error):
                self.showErrorAlert()
            }
        }
    }
    
    func webViewViewControllerDidCancel(_ vc: WebViewViewController) {
        dismiss(animated: true)
    }
}
