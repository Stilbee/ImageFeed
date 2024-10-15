//
//  ProfileImageService.swift
//  ImageFeed
//
//  Created by Alibi on 12.10.2024.
//

import Foundation

enum ProfileImageServiceError: Error {
    case invalidRequest
}

final class ProfileImageService {
    public static let shared = ProfileImageService()
    
    private init() {}
    
    static let didChangeNotification = Notification.Name(rawValue: "ProfileImageProviderDidChange")
    
    private let storage = OAuth2TokenStorage()
    private let usernameUrl = "https://api.unsplash.com/users/"
    
    private var task: URLSessionTask?
    private var lastUsername: String?
    
    private(set) var avatarURL: String?
    
    func fetchProfileImageURL(username: String, _ completion: @escaping (Result<String, Error>) -> Void) {
        assert(Thread.isMainThread)
        
        if task != nil {
            if lastUsername != username {
                task?.cancel()
            } else {
                completion(.failure(ProfileImageServiceError.invalidRequest))
                return
            }
        } else {
            if lastUsername == username {
                completion(.failure(ProfileImageServiceError.invalidRequest))
                return
            }
        }
        lastUsername = username
        
        guard let url = URL(string: usernameUrl + username) else {
            return
        }
        
        guard let accessToken = storage.accessToken else {
            return
        }
        
        var request = URLRequest(url: url)
        request.setValue("Bearer " + accessToken, forHTTPHeaderField: "Authorization")
        
        task = URLSession.shared.objectTask(for: request) { (result: Result<UserResult, Error>) in
            switch result {
            case .success(let data):
                let imageURL = data.profileImage?["large"] ?? ""
                self.avatarURL = imageURL
                
                NotificationCenter.default
                    .post(
                        name: ProfileImageService.didChangeNotification,
                        object: self,
                        userInfo: ["URL": imageURL]
                    )
                
                completion(.success(imageURL))
                break
            case .failure(let error):
                print("[fetchProfileImageURL]: [failure] [\(username)] \(error.localizedDescription)")
                completion(.failure(error))
                break
            }
            self.task = nil
            self.lastUsername = nil
        }
        
        task?.resume()
    }
}
