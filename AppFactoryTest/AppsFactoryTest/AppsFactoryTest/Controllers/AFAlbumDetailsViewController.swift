//
//  AFAlbumDetailsViewController.swift
//  AppsFactoryTest
//
//  Created by suricat on 03.11.18.
//  Copyright © 2018 suricat. All rights reserved.
//

import UIKit
import CoreData

struct AlbumDetails {
	var artistName : String?
	var albumName : String?
	var uniqueID : String?
}

enum ButtonStates : String {
	case save = "Save"
	case delete = "Delete"
}

class AFAlbumDetailsViewController: UIViewController {

	
	@IBOutlet weak var savedeleteButton: UIButton!
	var details: AlbumDetails?
	var album : MusicData.Album?
	
	var isItemFavorite : Bool?
    
	@IBAction func save_delete(_ sender: Any) {
		if let uniqueId = album?.uniqueId{
		if AFDataManager.isEntitySaved(uniqueId: uniqueId){
			deleteAlbum(sender as! UIButton)
		}else {
		saveAlbum(sender as! UIButton)
		}
		}
	}
	
	@IBOutlet weak var albumNameLabel: UILabel!
    @IBOutlet weak var albumImage: UIImageView!

    @IBOutlet weak var traksTableView: UITableView!
	
	override func viewDidLoad() {
        super.viewDidLoad()
        
        traksTableView.dataSource = self
        traksTableView.delegate = self
		
		savedeleteButton.isEnabled = false
        
		if let detailsSent = details{
			fetchDetails(with: detailsSent.artistName!, albumName: detailsSent.albumName!)
		}
		else {
			assertionFailure("no base object sent")
		}

    }
	
	func updateUI(from album: MusicData.Album){
		self.albumNameLabel.text = album.name
		if let imageNames = self.album?.imageList {
			if let imageAlbum = imageNames[3].text{
				guard let url = URL(string: imageAlbum) else {return}
				self.albumImage.kf.setImage(with: url)
			}
		}
		//set save/delete button text and state
		if let uniqueId = album.uniqueId{
			if AFDataManager.isEntitySaved(uniqueId: uniqueId){
				savedeleteButton.setTitle(ButtonStates.delete.rawValue, for: .normal)
			}else {
				savedeleteButton.setTitle(ButtonStates.save.rawValue, for: .normal)
			}
		}
		savedeleteButton.isEnabled = true
		
	}
    func  fetchDetails(with artist:String, albumName:String){
        AFDataManager.sharedInstance.fetchAlbumDetails(with: artist, albumName: albumName, success: { details in
			self.album = details
			self.album?.artistName = artist
			self.album?.uniqueId = details.uniqueId
			self.album?.imageList = details.imageList
			//update ui
			DispatchQueue.main.async{
				self.updateUI(from: (self.album)!)
			}
            self.traksTableView.reloadData()
        }) { error in
            print(error)
        }
    }

     func saveAlbum(_ sender: UIButton) {
        if createAlbumEntity() != nil {
            //save entity to context
            do {
                try CoreDataManager.sharedInstance.persistentContainer.viewContext.save()
				savedeleteButton.setTitle(ButtonStates.delete.rawValue, for: .normal)
            } catch let error {
                print(error)
            }
            //change button title to delete
        }
    }
    
     func deleteAlbum(_ sender: UIButton) {
        let context = CoreDataManager.sharedInstance.persistentContainer.viewContext
        let albumFetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName:"Album")
        let predicate = NSPredicate(format: "uniqueId == %@", album?.uniqueId ?? "")
        albumFetchRequest.predicate = predicate

        do {
            let records = try context.fetch(albumFetchRequest) as! [NSManagedObject]
            
            for record in records {
                context.delete(record)
            }
			savedeleteButton.setTitle(ButtonStates.save.rawValue, for: .normal)
            
        } catch let error as NSError{
            print(error.localizedDescription)
        }

    }
    
    private func createAlbumEntity() -> NSManagedObject? {
        let context = CoreDataManager.sharedInstance.persistentContainer.viewContext
        if let albumEntity = NSEntityDescription.insertNewObject(forEntityName: "Album", into: context) as? Album {
            albumEntity.name = self.details?.albumName
            albumEntity.artistName = self.details?.artistName
			albumEntity.uniqueId = self.album?.uniqueId
            
			if let imageList = self.album?.imageList {
				for image in imageList {
					if let imageEntity = NSEntityDescription.insertNewObject(forEntityName: "Image", into: context) as? Image {
						imageEntity.text = image.text
						imageEntity.size = image.size?.rawValue
						imageEntity.album = albumEntity
					}
				}
			}
            
			return albumEntity
        }
        return nil
    }
}

extension AFAlbumDetailsViewController: UITableViewDataSource, UITableViewDelegate{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return album?.tracks?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
       if  let traks = album?.tracks {
			let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
            let trackName = traks[indexPath.row].name
            cell.textLabel?.text = trackName
			return cell
        }
            return UITableViewCell()
}
}
