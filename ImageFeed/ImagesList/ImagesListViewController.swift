//
//  ViewController.swift
//  ImageFeed
//
//  Created by Alibi on 18.09.2024.
//

import UIKit
import Kingfisher

public protocol ImagesListViewControllerProtocol: AnyObject {
    var presenter: ImageListViewPresenterProtocol? { get set }
    func insertRows(_ indexPaths: [IndexPath])
    func showProgressBar()
    func hideProgressBar()
    func setCellLiked(at indexPath: IndexPath, _ isLiked: Bool)
}

final class ImagesListViewController: UIViewController & ImagesListViewControllerProtocol {
    var presenter: ImageListViewPresenterProtocol?
    
    private lazy var dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .long
        formatter.timeStyle = .none
        return formatter
    }()

    @IBOutlet private var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        presenter?.viewDidLoad()
        tableView.rowHeight = 200
        tableView.contentInset = UIEdgeInsets(top: 12, left: 0, bottom: 12, right: 0)
    }
    
    func insertRows(_ indexPaths: [IndexPath]) {
        tableView.performBatchUpdates {
            tableView.insertRows(at: indexPaths, with: .automatic)
        } completion: { _ in }
    }
    
    func showProgressBar() {
        UIBlockingProgressHUD.show()
    }
    
    func hideProgressBar() {
        UIBlockingProgressHUD.dismiss()
    }
    
    func setCellLiked(at indexPath: IndexPath, _ isLiked: Bool) {
        guard let cell = tableView.cellForRow(at: indexPath) as? ImagesListCell else {
            return
        }
        cell.setLiked(isLiked)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ShowSingleImage" {
            guard let viewController = segue.destination as? SingleImageViewController,
                    let indexPath = sender as? IndexPath
            else {
                assertionFailure("Invalid segue destination")
                return
            }

            viewController.imageUrlString = presenter?.photos[indexPath.row].largeImageURL
        } else {
            super.prepare(for: segue, sender: sender)
        }
    }
}

extension ImagesListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        presenter?.onDisplayRow(indexPath)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "ShowSingleImage", sender: indexPath)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        guard let photo = presenter?.photos[indexPath.row] else {
            return 0
        }
        
        let imageViewWidth = tableView.bounds.width - 32
        let imageWidth = photo.size.width
        
        let scale = imageViewWidth / imageWidth
        
        let imageHeight = scale * photo.size.height
        
        return imageHeight + 8
    }
}

extension ImagesListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return presenter?.photos.count ?? 0
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
        
        guard let photo = presenter?.photos[indexPath.row] else {
            return
        }
        
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
        guard let indexPath = tableView.indexPath(for: cell) else {
            return
        }
        presenter?.onTapLike(indexPath)
    }
}
