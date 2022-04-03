//
//  ComicsCollectionViewCell.swift
//  MarvelVK
//
//  Created by Tarlan Askaruly on 01.04.2022.
//

import UIKit

// MARK: -Structure for a cell
struct ComicCell {
    var name: String
    var imageURL: String
    
    init(name: String, imageURL: String) {
        self.name = name
        self.imageURL = imageURL
    }
}

class ComicsCollectionViewCell: UICollectionViewCell {
    
    static let cellIdentifier = "ComicsCollectionViewCell"
    
    // MARK: -IBOutlets
    @IBOutlet weak var comicIcon: UIImageView!
    @IBOutlet weak var comicName: UILabel!
    
    // MARK: -Methods
    func setupCell(_ comic: ComicCell) {
        self.comicIcon.loadThumbnail(urlSting: comic.imageURL)
        self.comicName.text = comic.name
    }
    
}
