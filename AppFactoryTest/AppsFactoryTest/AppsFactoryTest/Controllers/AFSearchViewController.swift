//
//  AFSearchViewController.swift
//  AppsFactoryTest
//
//  Created by suricat on 03.11.18.
//  Copyright © 2018 suricat. All rights reserved.
//

import UIKit

class AFSearchViewController: UIViewController {

    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var searchResultsTableView: UITableView!
    var selectionName : String?
    
    private var artists : [MusicData.Artist]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        searchResultsTableView.dataSource = self
        searchResultsTableView.delegate = self
        searchBar.delegate = self
        
        let searchNib = UINib(nibName: "SearchArtistTableViewCell", bundle: nil)
        searchResultsTableView.register(searchNib, forCellReuseIdentifier: "searchArtistCell")

    }
    
    func fetchArtists(name: String) {
        AFDataManager.sharedInstance.fetchArtists(with: name, success: { artists in
            self.artists = artists
            self.searchResultsTableView.reloadData()
        }, failure: { error in
            self.artists = nil
            self.searchResultsTableView.reloadData()
        })
    }
    

    
    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {

        let destination = segue.destination as? AFArtistAlbumsViewController
        //send selected artist name
        destination?.artistName = selectionName
    }

}

extension AFSearchViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return artists?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if let artists = self.artists, let cell = tableView.dequeueReusableCell(withIdentifier: "searchArtistCell", for: indexPath) as? SearchArtistTableViewCell {
            cell.artistNameLabel.text = artists[indexPath.row].name
            return cell
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let currentCell = tableView.cellForRow(at: indexPath) as! SearchArtistTableViewCell
        selectionName = currentCell.artistNameLabel.text
        performSegue(withIdentifier: "showAlbums", sender: self)
    }
    
}

extension AFSearchViewController: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        //request artists
        fetchArtists(name: self.searchBar.text ?? "")    }
}
