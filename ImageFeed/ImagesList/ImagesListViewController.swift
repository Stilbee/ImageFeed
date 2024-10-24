//
//  ViewController.swift
//  ImageFeed
//
//  Created by Alibi on 18.09.2024.
//

import UIKit

class ImagesListViewController: UIViewController {
    
    private let photosName: [String] = Array(0..<20).map{ "\($0)" }
    
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
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ShowSingleImage" { // 1
            guard let viewController = segue.destination as? SingleImageViewController, // 2
                    let indexPath = sender as? IndexPath // 3
            else {
                assertionFailure("Invalid segue destination") // 4
                return
            }

            let image = UIImage(named: photosName[indexPath.row]) // 5
            viewController.myImage = image
        } else {
            super.prepare(for: segue, sender: sender) // 7
        }
    }
}

extension ImagesListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) { 
        performSegue(withIdentifier: "ShowSingleImage", sender: indexPath)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        guard let image = UIImage(named: photosName[indexPath.row]) else {
            return 0
        }
        
        let imageViewWidth = tableView.bounds.width - 32
        let imageWidth = image.size.width
        
        let scale = imageViewWidth / imageWidth
        
        let imageHeight = scale * image.size.height
        
        return imageHeight + 8
    }
}

extension ImagesListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return photosName.count
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
        guard let image = UIImage(named: photosName[indexPath.row]) else {
            return
        }
        
        let nowDate = Date()
        
        cell.cellImage.image = image
        cell.dateLabel.text = dateFormatter.string(from: nowDate)
        
        if (indexPath.row % 2 == 0) {
            cell.likeButton.setImage(UIImage(named: "like_button_on"), for: .normal)
        } else {
            cell.likeButton.setImage(UIImage(named: "like_button_off"), for: .normal)
        }
    }
}
