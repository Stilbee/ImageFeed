//
//  ImagesListCell.swift
//  ImageFeed
//
//  Created by Alibi on 21.09.2024.
//

import Foundation
import UIKit
import Kingfisher

protocol ImagesListCellDelegate: AnyObject {
    func imageListCellDidTapLike(_ cell: ImagesListCell)
}

final class ImagesListCell: UITableViewCell {
    static let reuseIdentifier = "ImagesListCell"
    
    @IBOutlet var cellImage: UIImageView!
    @IBOutlet var likeButton: UIButton!
    @IBOutlet var dateLabel: UILabel!
    
    weak var delegate: ImagesListCellDelegate?
    
    @IBAction func likeButtonClicked(_ sender: Any) {
        delegate?.imageListCellDidTapLike(self)
    }
    
    override func prepareForReuse() {
        cellImage.kf.cancelDownloadTask()
    }
    
    public func setLiked(_ isLiked: Bool) {
        if (isLiked) {
            likeButton.setImage(UIImage(named: "like_button_on"), for: .normal)
        } else {
            likeButton.setImage(UIImage(named: "like_button_off"), for: .normal)
        }
    }
}
