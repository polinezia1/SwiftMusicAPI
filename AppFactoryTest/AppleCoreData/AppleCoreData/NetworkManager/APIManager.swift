//
//  Networking.swift
//  AppleCoreData
//
//  Created by suricat on 07.11.18.
//  Copyright © 2018 suricat. All rights reserved.
//

import UIKit
import Alamofire

enum ErrorCases: Error {
    case invalid_service
    case invalid_method
    case unwrappingError
    
    var localizedDescription: String{
		switch self {
		case .invalid_method:
			return "invalid method"
		default:
			return "server error"
		}
    }
}

    
struct APIManager {
	
	static func fetchArtists <T: Decodable>(with parameters: [String: Any],
										  decodingType:T.Type,
										  completion: @escaping (_ result: Decodable?, _ localizableError: String?) -> Void){

		guard let _url = MediaFeed.searchArtists.url else {
			completion(nil, ErrorCases.unwrappingError.localizedDescription)
			return
		}
		guard let url = URL(string: "http://ws.audioscrobbler.com/2.0/?method=artist.search&artist=cher&api_key=7708cffb338819aca303ac49c683f910&format=json") else {
			print(ErrorCases.invalid_service.localizedDescription)
			return
		}
		let request = Alamofire.request(url)
		//let request = Alamofire.request(url, method: HTTPMethod.get, parameters: parameters, encoding: JSONEncoding.default, headers: [:])
		request.responseString { response in

			if let data = response.data{
				do {
					let genericModel = try JSONDecoder().decode(decodingType, from: data)
					completion(genericModel, nil)
				}
				catch {
					completion(nil, ErrorCases.unwrappingError.localizedDescription)
				}
			}
		}
	}
	
	//generic fetch method
	
	static func fetchGenericData<T: Decodable>(modelType: T.Type, completion: @escaping (T) -> ()){
		
		guard let url = URL(string: "http://ws.audioscrobbler.com/2.0/?method=artist.search&artist=cher&api_key=7708cffb338819aca303ac49c683f910&format=json") else {
			print(ErrorCases.invalid_service.localizedDescription)
			return
		}
		
		Alamofire.request(url).responseJSON { response in
			
			if let data = response.data {
				
				do {
					if let parsedData = try JSONDecoder().decode(modelType.self, from: data) as? T{
						completion(parsedData)
					}
					else {
						print(ErrorCases.unwrappingError.localizedDescription)
					}
				}
				catch {print(ErrorCases.unwrappingError.localizedDescription)}
			}
			else {
				print(ErrorCases.invalid_service.localizedDescription)
			}
		}
	}
}
