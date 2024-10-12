//
//  OAuth2Service.swift
//  ImageFeed
//
//  Created by Alibi on 05.10.2024.
//

import Foundation

final class OAuth2Service {
    static let shared = OAuth2Service()

    private init() {}
    
    public func fetchOAuthToken(code: String, completeHandler: @escaping (Result<OAuthTokenResponseBody, Error>) -> Void) {
        guard var urlComponents = URLComponents(string: OAuth2ServiceConstants.unsplashTokenURLString)
        else {
            print("error: unsplashTokenURLString is nil!")
            return
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
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        
        let dataTask = URLSession.shared.data(for: request) { result in
            switch result {
            case .success(let data):
                do {
                    let decoder = JSONDecoder()
                    let response = try decoder.decode(OAuthTokenResponseBody.self, from: data)
                    completeHandler(.success(response))
                } catch {
                    completeHandler(.failure(error))
                }
                break
            case .failure(let error):
                print("error: while getting response from request!")
                print(error)
                completeHandler(.failure(error))
                break
            }
        }
        
        dataTask.resume()
    }
}

enum OAuth2ServiceConstants {
    static let unsplashTokenURLString = "https://unsplash.com/oauth/token"
}
