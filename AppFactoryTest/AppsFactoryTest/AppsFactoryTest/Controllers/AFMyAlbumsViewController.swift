//
//  ViewController.swift
//  AppsFactoryTest
//
//  Created by suricat on 03.11.18.
//  Copyright © 2018 suricat. All rights reserved.
//

import UIKit
import CoreData

class AFMyAlbumsViewController: UIViewController {
	
	@IBOutlet weak var myAlbumsCollectionView: UICollectionView!
	var album : MusicData.Album?
	
	lazy var fetchedhResultController: NSFetchedResultsController<NSFetchRequestResult> = {
		let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: String(describing: Album.self))
		fetchRequest.sortDescriptors = [NSSortDescriptor(key: "name", ascending: true)]
		let frc = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: CoreDataManager.sharedInstance.persistentContainer.viewContext, sectionNameKeyPath: nil, cacheName: nil)
		return frc
	}()
	
	@IBAction func showSearchPage(_ sender: Any) {
		
		performSegue(withIdentifier: "showSearchPage", sender: self)
	}
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		myAlbumsCollectionView.dataSource = self
		myAlbumsCollectionView.delegate = self
		
		//register cutom Cell
		let albumNib = UINib(nibName: "MyAlbumCollectionViewCell", bundle: nil)
		myAlbumsCollectionView.register(albumNib, forCellWithReuseIdentifier: "myAlbumCell")
		
	}
	
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		//retrieve saved albums
		do {
			try self.fetchedhResultController.performFetch()
		} catch let error  {
			print("ERROR: \(error)")
		}
		myAlbumsCollectionView.reloadData()
	}
	
	override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
		
		if segue.identifier == "showMyDetails"{
			if let destination = segue.destination as? AFAlbumDetailsViewController{
				// get selected album
				if let selectedIndex = myAlbumsCollectionView.indexPathsForSelectedItems?.first {
					if let album = fetchedhResultController.object(at: selectedIndex) as? Album {
						let detailsToSend = AlbumDetails(artistName: album.artistName, albumName: album.name, uniqueID: album.uniqueId)
						destination.details = detailsToSend
					}
				}
			}
		}
	}
}

extension AFMyAlbumsViewController: UICollectionViewDataSource, UICollectionViewDelegate,UICollectionViewDelegateFlowLayout {
	
	func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		if let count = fetchedhResultController.sections?.first?.numberOfObjects {
			return count
		}
		return 0
	}
	
	func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
		
		if let album = fetchedhResultController.object(at: indexPath) as? Album,
			let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "myAlbumCell", for: indexPath) as? MyAlbumCollectionViewCell {
			if let images = album.images as? Set<Image> {
				for image in images {
					if image.size == Size.large.rawValue
					{
						cell.updateCell(with: image.text ?? "", andFavorite: true)
						return cell
					}
				}
			}
		}
		return UICollectionViewCell()
	}
	
	func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
		
		performSegue(withIdentifier: "showMyDetails", sender: self)
	}
	
	func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
		return CGSize(width: 100, height: 100)
	}
}

