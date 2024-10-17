//
//  ImagesListService.swift
//  ImageFeed
//
//  Created by Alibi on 17.10.2024.
//

import Foundation

class ImagesListService {
    static let didChangeNotification = Notification.Name(rawValue: "ImagesListServiceDidChange")
    
    private let photosUrlString = "https://api.unsplash.com/photos"
    private(set) var photos: [Photo] = []
    
    private var lastLoadedPage: Int = 1
    private var task: URLSessionTask? = nil
    
    private let tokenStorage = OAuth2TokenStorage()
    
    public func fetchPhotosNextPage() {
        if task != nil {
            return
        }
        
        guard let request = createPhotoRequest() else {
            return
        }
        
        task = URLSession.shared.objectTask(for: request) {
            (result: Result<Array<PhotoResult>, Error>) in
            
            switch (result) {
            case .success(let response):
                self.addPhotos(from: response)
                self.lastLoadedPage += 1
                
                NotificationCenter.default
                    .post(
                        name: ImagesListService.didChangeNotification,
                        object: self,
                        userInfo: [:]
                    )
            case .failure(_):
                break
            }
            
            self.task = nil
        }
        
        task?.resume()
    }
    
    func changeLike(photoId: String, isLike: Bool, _ completeHandler: @escaping (Result<PhotoResult, Error>) -> Void) {
        guard let request = createLikeRequest(photoId, isLike) else {
            return
        }
        
        let task = URLSession.shared.objectTask(for: request) { (result: Result<LikeResult, Error>) in
            switch (result) {
            case .success(let likeResult):
                self.reverseLike(photoId)
                completeHandler(.success(likeResult.photo))
            case .failure(let error):
                completeHandler(.failure(error))
            }
        }
        task.resume()
    }
    
    private func reverseLike(_ photoId: String) {
        if let index = self.photos.firstIndex(where: { $0.id == photoId }) {
           let photo = self.photos[index]
           let newPhoto = Photo(
                id: photo.id,
                size: photo.size,
                createdAt: photo.createdAt,
                welcomeDescription: photo.welcomeDescription,
                thumbImageURL: photo.thumbImageURL,
                largeImageURL: photo.largeImageURL,
                isLiked: !photo.isLiked
            )
            self.photos[index] = newPhoto
        }
    }
    
    private func createLikeRequest(_ photoId: String, _ isLike: Bool) -> URLRequest? {
        guard let accessToken = tokenStorage.accessToken else {
            return nil
        }
        
        guard let url = URL(string: "\(photosUrlString)/\(photoId)/like") else {
            return nil
        }
        
        var request = URLRequest(url: url)
        request.setValue("Bearer " + accessToken, forHTTPHeaderField: "Authorization")
        request.httpMethod = isLike ? "POST" : "DELETE"
        
        return request
    }
    
    private func createPhotoRequest() -> URLRequest? {
        guard let accessToken = tokenStorage.accessToken else {
            return nil
        }
        
        guard var urlComponents = URLComponents(string: photosUrlString) else {
            return nil
        }
        
        urlComponents.queryItems = [
            URLQueryItem(name: "page", value: "\(lastLoadedPage)"),
            URLQueryItem(name: "per_page", value: "100")
        ]
        
        guard let url = urlComponents.url else {
            return nil
        }
        
        var request = URLRequest(url: url)
        request.setValue("Bearer " + accessToken, forHTTPHeaderField: "Authorization")
        
        return request
    }
    
    private func addPhotos(from photosResponse: Array<PhotoResult>) {
        for i in photosResponse {
            let photo = convert(response: i)
            photos.append(photo)
        }
    }
    
    private func convert(response: PhotoResult) -> Photo {
        return Photo(
            id: response.id, 
            size: .init(width: response.width, height: response.height),
            createdAt: response.createdAt,
            welcomeDescription: response.description,
            thumbImageURL: response.urls.regular,
            largeImageURL: response.urls.full,
            isLiked: response.likedByUser
        )
    }
}
