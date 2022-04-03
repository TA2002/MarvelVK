//
//  ViewController.swift
//  MarvelVK
//
//  Created by Tarlan Askaruly on 30.03.2022.
//

import UIKit

class MasterViewController: UIViewController {
    
    // MARK: -Internal variables
    private var characters = [MarvelCharacter]()
    private let apiClient = MarvelClient()
    private var apiResultsOffset: Int?
    private let searchController = UISearchController()
    // MARK: -External variables
    // MARK: -UI Elements
    @IBOutlet weak var heroTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "MARVEL"
        searchController.searchResultsUpdater = self
        navigationItem.searchController = searchController
        
        heroTableView.delegate = self
        heroTableView.dataSource = self
        heroTableView.separatorStyle = .none
        
        getCharacters(startsWith: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if  segue.identifier == "toDetail",
            let destination = segue.destination as? DetailViewController,
            let index = heroTableView.indexPathForSelectedRow?.row
        {
            destination.character = characters[index]
        }
    }

    // MARK: -Methods
    private func getCharacters(startsWith: String?) {
        apiClient.sendRequest(offset: apiResultsOffset, startsWith: startsWith) { [weak self] data, error in
            if let error = error {
                print(error.localizedDescription)
            }
            else {
                if let results = data?.data?.results {
                    self?.characters.append(contentsOf: results)
                    DispatchQueue.main.async {
                        self?.heroTableView.reloadData()
                    }
                }
            }
        }
    }
}

extension MasterViewController: UITableViewDelegate, UITableViewDataSource, UIScrollViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return characters.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: HeroListCell.cellIdentifier, for: indexPath) as! HeroListCell
        cell.setupCell(characters[indexPath.row])
        cell.selectionStyle = .none
        return cell
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let position = scrollView.contentOffset.y
        if position > (heroTableView.contentSize.height - 100 - scrollView.frame.size.height) {
            print("called")
            if !apiClient.isActive {
                print("calledIn")
                apiResultsOffset = characters.count
                getCharacters(startsWith: searchController.searchBar.text)
            }
        }
    }
    
}

extension MasterViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        guard let query = searchController.searchBar.text else {
            return
        }
        apiClient.isActive = false
        apiClient.task?.cancel()
        characters = []
        heroTableView.reloadData()
        apiResultsOffset = characters.count
        getCharacters(startsWith: query)
    }
}

