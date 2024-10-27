//
//  ImageListViewProtocol.swift
//  ImageFeed
//
//  Created by Alibi on 27.10.2024.
//

import Foundation

public protocol ImageListViewPresenterProtocol {
    var view: ImagesListViewControllerProtocol? { get set }
    var photos: [Photo] { get }
    func viewDidLoad()
    func onDisplayRow(_ indexPath: IndexPath)
    func onTapLike(_ indexPath: IndexPath)
}

final class ImageListViewPresenter: ImageListViewPresenterProtocol {
    var view: ImagesListViewControllerProtocol?
    var imageListService: ImagesListServiceProtocol
    private(set) var photos: [Photo] = []
    
    init(imageListService: ImagesListServiceProtocol = ImagesListService()) {
        self.imageListService = imageListService
    }
    
    func viewDidLoad() {
        NotificationCenter.default
            .addObserver(
                forName: ImagesListService.didChangeNotification,
                object: nil,
                queue: .main
            ) { [weak self] _ in
                guard let self = self else { return }
                self.updateTableViewAnimated()
            }
        
        imageListService.fetchPhotosNextPage()
    }
    
    func updateTableViewAnimated() {
        let oldCount = photos.count // 0
        let newCount = imageListService.photos.count // 10
        photos = imageListService.photos
        
        if oldCount != newCount {
            let indexPaths = (oldCount..<newCount).map { i in
                IndexPath(row: i, section: 0)
            }
            view?.insertRows(indexPaths)
        }
    }
    
    func onDisplayRow(_ indexPath: IndexPath) {
        if indexPath.row + 1 == photos.count {
            imageListService.fetchPhotosNextPage()
        }
    }
    
    func onTapLike(_ indexPath: IndexPath) {
        let photo = photos[indexPath.row]
    
        view?.showProgressBar()
        
        imageListService.changeLike(photoId: photo.id, isLike: !photo.isLiked) { [weak self] result in
            
            self?.view?.showProgressBar()
            
            switch result {
            case .success:
                self?.photos = self?.imageListService.photos ?? []
                
                let isLiked = self?.photos[indexPath.row].isLiked ?? !photo.isLiked
                self?.view?.setCellLiked(at: indexPath, isLiked)
            case .failure:
                // TODO: Показать ошибку с использованием UIAlertController
                break
            }
        }
    }
}
