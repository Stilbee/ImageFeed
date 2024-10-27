//
//  ProfileViewTests.swift
//  ImageFeedTests
//
//  Created by Alibi on 27.10.2024.
//

@testable import ImageFeed
import XCTest

final class ProfileViewTests: XCTestCase {
    func testViewControllerCallsViewDidLoad() {
        //given
        let presenter = ProfileViewPresenterSpy()
        
        let viewController = ProfileViewController()
        presenter.view = viewController
        viewController.presenter = presenter
        
        //when
        _ = viewController.view
        
        //then
        XCTAssertTrue(presenter.viewDidLoadCalled) //behaviour verification
    }
    
    func testViewControllerLoadedProfile() {
        //given
        let profileService = ProfileServiceSpy()
        profileService.profile = Profile(username: "test_username", loginName: "test_login", name: "test_name", bio: "test_bio")
        
        let presenter = ProfileViewPresenter(profileService: profileService)
        
        let viewController = ProfileViewControllerSpy()
        presenter.view = viewController
        viewController.presenter = presenter
        
        //when
        presenter.viewDidLoad()
        
        //then
        XCTAssertEqual(viewController.nameText, "test_name")
        XCTAssertEqual(viewController.loginText, "test_login")
        XCTAssertEqual(viewController.bioText, "test_bio")
    }
    
    func testViewControllerLoadedAvatarUrl() {
        //given
        let profileService = ProfileServiceSpy()
        let profileImageService = ProfileImageServiceSpy()
        profileImageService.avatarURL = "https://images.unsplash.com"
        
        let presenter = ProfileViewPresenter(profileService: profileService, profileImageService: profileImageService)
        
        let viewController = ProfileViewControllerSpy()
        presenter.view = viewController
        viewController.presenter = presenter
    
        //when
        presenter.viewDidLoad()
        
        //then
        XCTAssertEqual(viewController.avatarURL?.absoluteString, "https://images.unsplash.com")
    }
}
