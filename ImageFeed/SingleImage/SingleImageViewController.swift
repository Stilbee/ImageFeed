//
//  SingleImageViewController.swift
//  ImageFeed
//
//  Created by Alibi on 25.09.2024.
//

import UIKit

class SingleImageViewController: UIViewController {
    
    var myImage: UIImage? {
        didSet {
            guard isViewLoaded, let myImage else { return }

            imageView.image = myImage
            imageView.frame.size = myImage.size
            rescaleAndCenterImageInScrollView(image: myImage)
        }
    }
    
    @IBOutlet private var scrollView: UIScrollView!
    @IBOutlet private var imageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        scrollView.minimumZoomScale = 0.1
        scrollView.maximumZoomScale = 1.25
        
        guard let myImage else { return }
        imageView.image = myImage
        imageView.frame.size = myImage.size
        rescaleAndCenterImageInScrollView(image: myImage)
    }
    
    @IBAction func didClickBackButton(_ sender: Any) {
        dismiss(animated: true)
    }
    
    @IBAction func didTapShareButton(_ sender: Any) {
        guard let myImage else { return }
        let share = UIActivityViewController(
            activityItems: [myImage],
            applicationActivities: nil
        )
        present(share, animated: true, completion: nil)
    }
   
    private func rescaleAndCenterImageInScrollView(image: UIImage) {
        let minZoomScale = scrollView.minimumZoomScale
        let maxZoomScale = scrollView.maximumZoomScale
        view.layoutIfNeeded()
        let visibleRectSize = scrollView.bounds.size
        let imageSize = image.size
        let hScale = visibleRectSize.width / imageSize.width
        let vScale = visibleRectSize.height / imageSize.height
        let scale = min(maxZoomScale, max(minZoomScale, min(hScale, vScale)))
        scrollView.setZoomScale(scale, animated: false)
        
        
        scrollView.layoutIfNeeded()
        let newContentSize = scrollView.contentSize
        let x = (newContentSize.width - visibleRectSize.width) / 2
        let y = (newContentSize.height - visibleRectSize.height) / 2
        scrollView.setContentOffset(CGPoint(x: x, y: y), animated: false)
    }
}

extension SingleImageViewController: UIScrollViewDelegate {
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return imageView
    }
}
