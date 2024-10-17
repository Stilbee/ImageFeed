//
//  ImagesListCell.swift
//  ImageFeed
//
//  Created by Alibi on 21.09.2024.
//

import Foundation
import UIKit

final class ImagesListCell: UITableViewCell {
    static let reuseIdentifier = "ImagesListCell"
    
    @IBOutlet private var cellImage: UIImageView!
    @IBOutlet private var likeButton: UIButton!
    @IBOutlet private var dateLabel: UILabel!
}
