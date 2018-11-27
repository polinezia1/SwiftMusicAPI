//
//  ArtistAllAlbumsViewController.swift
//  AppsFactoryTest
//
//  Created by suricat on 03.11.18.
//  Copyright © 2018 suricat. All rights reserved.
//

import UIKit
import CoreData

class AFArtistAlbumsViewController: UIViewController {

    @IBOutlet weak var albumsCollectionView: UICollectionView!
    var artistName : String?
    var albums : [MusicData.Album]?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        albumsCollectionView.dataSource = self
        albumsCollectionView.delegate = self
        
        let albumNib = UINib(nibName: "MyAlbumCollectionViewCell", bundle: nil)
        albumsCollectionView.register(albumNib, forCellWithReuseIdentifier: "myAlbumCell")
        
        self.title = artistName
        
        fetchAlbums(forArtist: self.artistName ?? "")
    }
	
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		albumsCollectionView.reloadData()
	}
    
    func fetchAlbums(forArtist name:String){
        AFDataManager.sharedInstance.fetchArtistAlbums(with: name, succes: { albums in
            self.albums = albums
            self.albumsCollectionView.reloadData()
        }) { error in
            self.albums = nil
            self.albumsCollectionView.reloadData()
        }
    }

    
    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "showDetails"{
            if let destination = segue.destination as? AFAlbumDetailsViewController{
                let index = self.albumsCollectionView.indexPathsForSelectedItems?.first
				if let albumSelected = albums?[(index?.row)!] {
					let detailsToSend = AlbumDetails(artistName: albumSelected.artistName, albumName: albumSelected.name, uniqueID: albumSelected.uniqueId)
				destination.details = detailsToSend
				}
            }
        }
    }

}

extension AFArtistAlbumsViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return albums?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if let albums = self.albums, let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "myAlbumCell", for: indexPath) as? MyAlbumCollectionViewCell{
			let album = albums[indexPath.row]
			if let imageNames = album.imageList, let uniqueId = album.uniqueId{
                
                let imageAlbum = imageNames[3].text ?? ""
				var isFav = false
				//check if saved
				let context = CoreDataManager.sharedInstance.persistentContainer.viewContext
				let fetchReq = NSFetchRequest<NSFetchRequestResult>(entityName: "Album")
				let predicate = NSPredicate(format: "uniqueId = %@", uniqueId)
				fetchReq.predicate = predicate
				
				do {
					let results = try context.fetch(fetchReq)
					if results.count > 0 {
						isFav = true
					}
				}catch let error {print(error.localizedDescription)}
				cell.updateCell(with: imageAlbum, andFavorite: isFav)
            }
            
            return cell
        }
        
        return UICollectionViewCell()
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 100, height: 100)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        performSegue(withIdentifier: "showDetails", sender: self)
    }
}
