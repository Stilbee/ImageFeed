//
//  ViewController.swift
//  ImageFeed
//
//  Created by Alibi on 18.09.2024.
//

import UIKit
import Kingfisher

class ImagesListViewController: UIViewController {
    
    private let imageService = ImagesListService()
    private var photos: [Photo] = []
    
    private lazy var dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .long
        formatter.timeStyle = .none
        return formatter
    }()

    @IBOutlet private var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.rowHeight = 200
        tableView.contentInset = UIEdgeInsets(top: 12, left: 0, bottom: 12, right: 0)
        
        NotificationCenter.default
            .addObserver(
                forName: ImagesListService.didChangeNotification,
                object: nil,
                queue: .main
            ) { [weak self] _ in
                guard let self = self else { return }
                self.updateTableViewAnimated()
            }
        
        imageService.fetchPhotosNextPage()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ShowSingleImage" {
            guard let viewController = segue.destination as? SingleImageViewController,
                    let indexPath = sender as? IndexPath
            else {
                assertionFailure("Invalid segue destination")
                return
            }

            viewController.imageUrlString = photos[indexPath.row].largeImageURL
        } else {
            super.prepare(for: segue, sender: sender)
        }
    }
    
    func updateTableViewAnimated() {
        let oldCount = photos.count // 0
        let newCount = imageService.photos.count // 10
        photos = imageService.photos
        if oldCount != newCount {
            tableView.performBatchUpdates {
                let indexPaths = (oldCount..<newCount).map { i in
                    IndexPath(row: i, section: 0)
                }
                tableView.insertRows(at: indexPaths, with: .automatic)
            } completion: { _ in }
        }
    }
}

extension ImagesListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row + 1 == photos.count {
            imageService.fetchPhotosNextPage()
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "ShowSingleImage", sender: indexPath)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let photo = photos[indexPath.row]
        
        let imageViewWidth = tableView.bounds.width - 32
        let imageWidth = photo.size.width
        
        let scale = imageViewWidth / imageWidth
        
        let imageHeight = scale * photo.size.height
        
        return imageHeight + 8
    }
}

extension ImagesListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return photos.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ImagesListCell.reuseIdentifier, for: indexPath)
            
        guard let imageListCell = cell as? ImagesListCell else {
            return UITableViewCell()
        }
        
        configCell(for: imageListCell, with: indexPath)
        return imageListCell
    }
    
    func configCell(for cell: ImagesListCell, with indexPath: IndexPath) {
        cell.delegate = self
        
        let photo = photos[indexPath.row]
        
        if let imageUrl = URL(string: photo.thumbImageURL) {
            // TODO: Fix placeholder and indicator
            cell.cellImage?.kf
                .setImage(with: imageUrl,
                          placeholder: UIImage(named: "stub"))
            cell.cellImage.kf.indicatorType = .activity
        }
        if let date = photo.createdAt {
            cell.dateLabel.text = dateFormatter.string(from: date)
        }
        
        cell.setLiked(photo.isLiked)
    }
}

extension ImagesListViewController: ImagesListCellDelegate {
    func imageListCellDidTapLike(_ cell: ImagesListCell) {
        guard let indexPath = tableView.indexPath(for: cell) else { return }
        let photo = photos[indexPath.row]
        
        UIBlockingProgressHUD.show()
        
        imageService.changeLike(photoId: photo.id, isLike: !photo.isLiked) { result in
            
            UIBlockingProgressHUD.dismiss()
            
            switch result {
            case .success:
                self.photos = self.imageService.photos
                cell.setLiked(self.photos[indexPath.row].isLiked)
            case .failure:
                // TODO: Показать ошибку с использованием UIAlertController
                break
            }
        }
    }
}
