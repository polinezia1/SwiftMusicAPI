//
//  ViewController.swift
//  AppleCoreData
//
//  Created by suricat on 07.11.18.
//  Copyright © 2018 suricat. All rights reserved.
//

import UIKit

class MyAlbumsViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
		
		//test

		APIManager.fetchGenericData(modelType: ArtistSearch.self) { (artists: ArtistSearch) in
			if let numberOfArtists = artists.searchTerm{
				print(numberOfArtists)
			}
		}
		APIManager.fetchArtists(with: ["":""], decodingType: ArtistSearch.self) { (result, error) in
			print(result)
		}
    }
}

