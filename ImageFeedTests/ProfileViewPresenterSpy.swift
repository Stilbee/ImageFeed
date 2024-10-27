//
//  ProfileViewPresenterSpy.swift
//  ImageFeedTests
//
//  Created by Alibi on 27.10.2024.
//

import ImageFeed
import Foundation

final class ProfileViewPresenterSpy: ProfileViewPresenterProtocol {
    var viewDidLoadCalled: Bool = false
    var view: ProfileViewControllerProtocol?
    
    func viewDidLoad() {
        viewDidLoadCalled = true
    }
}
