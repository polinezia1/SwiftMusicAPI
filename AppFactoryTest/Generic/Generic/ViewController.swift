//
//  ViewController.swift
//  Generic
//
//  Created by suricat on 14.11.18.
//  Copyright © 2018 suricat. All rights reserved.
//

import UIKit
import CoreData

class ViewController: UIViewController {
	
	@IBOutlet weak var savedData: UITableView!
	lazy var fetchResultController : NSFetchedResultsController<NSFetchRequestResult> = {
		
		let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: String(describing: Artist.self))
		fetchRequest.sortDescriptors = [NSSortDescriptor(key: "name", ascending: true)]
		let frc = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: CoreDataManager.sharedInstance.persistentContainer.viewContext, sectionNameKeyPath: nil, cacheName: nil)
		return frc
	}()

	override func viewDidLoad() {
		super.viewDidLoad()

		savedData.dataSource = self
		savedData.delegate = self
		
	/*	APIManager.sharedInstance.fetchGenericData { (result: WeatherForecast) in
			print(result)
		}
		
		APIManager.sharedInstance.fetchGenericData { (result: ArtistSearchModel) in
			if let term = result.searchTerm {
				print(term)
			}
			print("no artists matching string")
		}
		*/
		
		//Fetch saved data
		do {
			try self.fetchResultController.performFetch()
				savedData.reloadData()
		}catch let error as NSError {print(error)}
		
		//print(self.fetchResultController.fetchedObjects ?? "")

		APIManager.sharedInstance.fetchGenericData { (result: MediaArtistSearch) in
			if let allArtists = result.results.artistmatches?.artist {
				for artist in allArtists {
					//create artist managedObject
					if self.createArtistEntity(with: artist) != nil {
						//save entity to context
						do {
							try CoreDataManager.sharedInstance.persistentContainer.viewContext.save()
						} catch let error {
							print(error)
						}
						//change button title to delete
					}
				}
			}
		}
	}

	private func createArtistEntity(with artist: Artist) -> NSManagedObject? {
		let context = CoreDataManager.sharedInstance.persistentContainer.viewContext
		if let artistEntity = NSEntityDescription.insertNewObject(forEntityName: "Artist", into: context) as? ArtistMO {
			
			artistEntity.name = artist.name
			
			return artistEntity
		}
		return nil
	}

}

extension ViewController: UITableViewDelegate, UITableViewDataSource {
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return fetchResultController.sections?.first?.numberOfObjects ?? 0
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		
		guard let cell = tableView.dequeueReusableCell(withIdentifier: "cell") else{
			return UITableViewCell()
		}
		let entity = fetchResultController.object(at: indexPath) as? ArtistMO
		cell.textLabel?.text = entity?.name
		return cell
	}
	
	
	
}

