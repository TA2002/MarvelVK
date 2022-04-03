//
//  HeroListCellCell.swift
//  MarvelVK
//
//  Created by Tarlan Askaruly on 30.03.2022.
//

import UIKit

class HeroListCell: UITableViewCell {

    static let cellIdentifier = "HeroListCell"
    
    // MARK: -IBOutlets
    @IBOutlet weak var heroName: UILabel!
    @IBOutlet weak var heroImage: UIImageView!
    @IBOutlet weak var nameBgView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    // MARK: -Methods
    func setupCell(_ character: MarvelCharacter) {
        heroName.text = character.name
        let image_url = "https\(character.thumbnail.path.dropFirst(4)).\(character.thumbnail.extension)"
        heroImage.loadThumbnail(urlSting: image_url)
    }
    
}
