//
//  DetailViewController.swift
//  MarvelVK
//
//  Created by Tarlan Askaruly on 01.04.2022.
//

import UIKit

class DetailViewController: UIViewController {

    // MARK: -IBOutlets
    @IBOutlet weak var characterName: UILabel!
    @IBOutlet weak var characterImage: UIImageView!
    @IBOutlet weak var characterDescription: UILabel!
    @IBOutlet weak var comicsCollectionView: UICollectionView!
    
    // MARK: -External variables
    var character: MarvelCharacter?
    
    // MARK: -Internal variables
    private var comicsData = [MarvelComic]()
    private let apiClient = MarvelClient()
    private var comicCells = [ComicCell]()
    private let queue = DispatchQueue(label: "bgThread")
    private var resultCounter = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        comicsCollectionView.delegate = self
        comicsCollectionView.dataSource = self
        navigationController?.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        
        if let character = character {
            comicsData = character.comics.items
            print("description: \(character.description)")
            characterImage.loadThumbnail(urlSting: "https\(character.thumbnail.path.dropFirst(4)).\(character.thumbnail.extension)")
            characterName.text = character.name
            characterDescription.text = character.description
            for comic in comicsData {
                comicCells.append(ComicCell(name: comic.name, imageURL: ""))
            }
            getComicsDetails()
        }
    }
    
    // MARK: -Methods
    
    private func getComicsDetails() {
        resultCounter = 0
        
        for index in 0..<comicsData.count {
            apiClient.sendComicRequest(url: "https\(comicsData[index].resourceURI.dropFirst(4))") { [weak self] data, error in
                if let error = error {
                    print(error.localizedDescription)
                }
                else {
                    if let results = data?.data?.results {
                        self?.queue.async {
                            let image_url = "https\(results[0].thumbnail.path.dropFirst(4)).\(results[0].thumbnail.extension)"
                            self?.comicCells[index].imageURL = image_url
                            self?.resultCounter += 1
                            if self?.resultCounter == self?.comicCells.count {
                                DispatchQueue.main.async {
                                    self?.comicsCollectionView.reloadData()
                                }
                            }
                        }
                    }
                }
            }
        }
        
    }

}

extension DetailViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return comicCells.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ComicsCollectionViewCell.cellIdentifier, for: indexPath) as! ComicsCollectionViewCell
        cell.comicName.text = comicsData[indexPath.row].name
        cell.setupCell(comicCells[indexPath.row])
        return cell
    }
    
    
}
