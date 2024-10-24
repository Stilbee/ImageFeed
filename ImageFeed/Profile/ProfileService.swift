//
//  ProfileService.swift
//  ImageFeed
//
//  Created by Alibi on 12.10.2024.
//

import Foundation

class ProfileService {
    public static let shared = ProfileService()
    
    private init() {}
    
    private let meUrlString = "https://api.unsplash.com/me"
    private(set) var profile: Profile?
    
    public func fetchProfile(_ accessToken: String, completeHandler: @escaping (Result<ProfileResult, Error>) -> Void) {
        guard let url = URL(string: meUrlString) else {
            return
        }
        
        var request = URLRequest(url: url)
        request.setValue("Bearer " + accessToken, forHTTPHeaderField: "Authorization")
        
        let task = URLSession.shared.objectTask(for: request) { (result: Result<ProfileResult, Error>) in
            switch result {
            case .success(let data):
                self.profile = self.convertResponseToProfile(data)
                completeHandler(.success(data))
                break
            case .failure(let error):
                print("[fetchProfile]: [failure] [\(accessToken)] \(error.localizedDescription)")
                completeHandler(.failure(error))
                break
            }
        }
        
        task.resume()
    }
    
    private func convertResponseToProfile(_ response: ProfileResult) -> Profile {
        return Profile(
            username: response.username,
            loginName: "@" + response.username,
            name: response.firstName + " " + (response.lastName ?? ""),
            bio: response.bio
        )
    }
    
    public func cleanProfile() {
        profile = nil
    }
}
