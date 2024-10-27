//
//  ImageListPresenterSpy.swift
//  ImageFeedTests
//
//  Created by Alibi on 27.10.2024.
//

import ImageFeed
import Foundation

class ImageListViewPresenterSpy: ImageListViewPresenterProtocol {
    var view: ImageFeed.ImagesListViewControllerProtocol?
    
    var photos: [ImageFeed.Photo] = []
    
    var viewDidLoadCalled: Bool = false
    
    func viewDidLoad() {
        viewDidLoadCalled = true
    }
    
    func onDisplayRow(_ indexPath: IndexPath) {
        
    }
    
    func onTapLike(_ indexPath: IndexPath) {
        
    }
}
