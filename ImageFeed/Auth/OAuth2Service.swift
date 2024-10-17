//
//  OAuth2Service.swift
//  ImageFeed
//
//  Created by Alibi on 05.10.2024.
//

import Foundation

enum AuthServiceError: Error {
    case invalidRequest
}

final class OAuth2Service {
    static let shared = OAuth2Service()

    private var task: URLSessionTask?
    private var lastCode: String?
    
    private init() {}
    
    public func fetchOAuthToken(code: String, completeHandler: @escaping (Result<String, Error>) -> Void) {
        assert(Thread.isMainThread)
        
        if task != nil {
            if lastCode != code {
                task?.cancel()
            } else {
                completeHandler(.failure(AuthServiceError.invalidRequest))
                return
            }
        } else {
            if lastCode == code {
                completeHandler(.failure(AuthServiceError.invalidRequest))
                return
            }
        }
        lastCode = code
        
        guard let url = createRequestUrl(with: code) else {
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        
        task = URLSession.shared.objectTask(for: request) { (result: Result<OAuthTokenResponseBody, Error>) in
            switch result {
            case .success(let data):
                completeHandler(.success(data.accessToken))
                break
            case .failure(let error):
                print("[fetchOAuthToken]: [failure] [\(code)] \(error.localizedDescription)")
                completeHandler(.failure(error))
                break
            }
            self.task = nil
            self.lastCode = nil
        }
        
        task?.resume()
    }
    
    private func createRequestUrl(with code: String) -> URL? {
        guard var urlComponents = URLComponents(string: OAuth2ServiceConstants.unsplashTokenURLString)
        else {
            print("error: unsplashTokenURLString is nil!")
            return nil
        }
        
        urlComponents.queryItems = [
            URLQueryItem(name: "client_id", value: Constants.accessKey),
            URLQueryItem(name: "client_secret", value: Constants.secretKey),
            URLQueryItem(name: "redirect_uri", value: Constants.redirectURI),
            URLQueryItem(name: "grant_type", value: "authorization_code"),
            URLQueryItem(name: "code", value: code)
        ]
        
        guard let url = urlComponents.url else {
            print("error: urlComponent is nil!")
            return nil
        }
        return url
    }
}

enum OAuth2ServiceConstants {
    static let unsplashTokenURLString = "https://unsplash.com/oauth/token"
}
