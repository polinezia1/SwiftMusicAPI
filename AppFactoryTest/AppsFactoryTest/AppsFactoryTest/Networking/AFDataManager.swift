//
//  AFDataManager.swift
//  AppsFactoryTest
//
//  Created by suricat on 03.11.18.
//  Copyright © 2018 suricat. All rights reserved.
//

import UIKit
import Alamofire
import CoreData

class AFDataManager: NSObject {
    
    static let sharedInstance : AFDataManager = AFDataManager()
    
    static let baseUrl = "http://ws.audioscrobbler.com/2.0/"
    static let apiKey = "36c599f92144e2e8ad89adc8ecb3953d"
    
    private let artistSearchUrl = "\(baseUrl)?method=artist.search&artist=%@&api_key=\(apiKey)&format=json"
    private let albumsFetchUrl = "\(baseUrl)?method=artist.gettopalbums&artist=%@&api_key=\(apiKey)&format=json"
    private let albumDetails = "\(baseUrl)?method=album.getinfo&api_key=d708cac67d15fd1ef206d0fa5cf170d9&artist=%@&album=%@&format=json"
	
	static func isEntitySaved(uniqueId: String) -> Bool {
		
		let context = CoreDataManager.sharedInstance.persistentContainer.viewContext
		let fetchReq = NSFetchRequest<NSFetchRequestResult>(entityName: "Album")
		let predicate = NSPredicate(format: "uniqueId = %@", uniqueId)
		fetchReq.predicate = predicate
		
		do {
			let results = try context.fetch(fetchReq)
			if results.count > 0 {
				return true
			}
		}catch let error {
			print(error.localizedDescription)
		}
			return false
	}
	
	func fetchA(with name:String, success: @escaping (([MusicData.Artist]) -> Void), failure: @escaping ((String) -> Void)){

		let requestUrl = String(format: artistSearchUrl, name)
		guard let url = URL(string: requestUrl) else {
			return
		}
		
		URLSession.shared.dataTask(with: url) { (data, response, error) in
			
			guard let dataResp = data else{
				//assertionFailure()
				return
			}
			do {
				let responseParsed = try JSONDecoder().decode(MusicData.Artist.self, from: dataResp)
				success(responseParsed)
			}catch let error as NSError{
				failure(error.localizedDescription)
			}
		}.resume()
	}
	
    func fetchArtists(with name:String, success: @escaping (([MusicData.Artist]) -> Void), failure: @escaping ((String) -> Void)){
        
        let requestUrl = String(format: artistSearchUrl, name)
        guard let url = URL(string: requestUrl) else {
            return
        }
        
        Alamofire.request(url).responseJSON { response in
            
            if let data = response.data {
                do {
                    if let parsedData = try JSONSerialization.jsonObject(with: data) as? [String:Any] {
                        if let artistData = MusicData(JSON: parsedData), let artists = artistData.artists {
                            success(artists)
                        } else {
                            failure("failed to parse content")
                        }
                    }else{
                        failure("failed to serialize")
                    }
                } catch let error as NSError {
                    failure(error.localizedDescription)
                }
            }
        }
    }
    
    func fetchArtistAlbums(with name:String, succes: @escaping (([MusicData.Album]) -> Void), failure: @escaping ((String) -> Void)){
        
        let encodedName = name.addingPercentEncoding(withAllowedCharacters: .alphanumerics)

        let requestUrl = String(format: albumsFetchUrl, encodedName!)
        guard let url = URL(string: requestUrl) else {
            return
        }
        
        Alamofire.request(url).responseJSON { response in
            
            if let data = response.data {
                do {
                    if let parsedData = try JSONSerialization.jsonObject(with: data) as? [String:Any] {
                        if let albumsData = MusicData(JSON: parsedData), let albums = albumsData.albums {
                            succes(albums)
                        }else{
                            failure("failed to parse content")
                        }
                    }else{
                        failure("failed to serialize")
                    }
                }catch let error as NSError {
                    failure(error.localizedDescription)
                }
            }
        }
    }
    
    func fetchAlbumDetails(with name: String, albumName: String, success: @escaping ((MusicData.Album) -> Void), failure: @escaping ((String) -> Void)){
        
		let encodedName = name.addingPercentEncoding(withAllowedCharacters: .alphanumerics)
		let encodedAlbum = albumName.addingPercentEncoding(withAllowedCharacters: .alphanumerics)

        let requestUrl = String(format: albumDetails, encodedName!, encodedAlbum!)
        guard let url = URL(string: requestUrl) else {
            return
        }
        Alamofire.request(url).responseJSON { response in
            
            if let data = response.data{
                do {
                    if let parsedData = try JSONSerialization.jsonObject(with: data) as? [String:Any]{
                        if let albumDetails = MusicData(JSON: parsedData), let details = albumDetails.details{
                            success(details)
                        }else{
                            failure("failed to parse content")
                        }
                    }else{
                            failure("failed to serialize")
                        }
                    }catch let error as NSError {
                        failure(error.localizedDescription)
                    }
                }
            }
        }
    }
