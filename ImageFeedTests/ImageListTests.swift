//
//  ImageListTests.swift
//  ImageFeedTests
//
//  Created by Alibi on 27.10.2024.
//

@testable import ImageFeed
import XCTest

final class ImageListTests: XCTestCase {
    func testViewControllerCallsViewDidLoad() {
        //given
        let presenter = ImageListViewPresenterSpy()
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let viewController = storyboard.instantiateViewController(
            withIdentifier: "ImagesListViewController"
        ) as! ImagesListViewController
        presenter.view = viewController
        viewController.presenter = presenter
        
        //when
        _ = viewController.view
        
        //then
        XCTAssertTrue(presenter.viewDidLoadCalled) //behaviour verification
    }
}
