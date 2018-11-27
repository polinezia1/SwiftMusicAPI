//
//  APIManager.swift
//  Generic
//
//  Created by suricat on 14.11.18.
//  Copyright © 2018 suricat. All rights reserved.
//

import UIKit
import Alamofire

class APIManager: NSObject {
	
	static let sharedInstance = APIManager()
	
	func fetchGenericData<T: Decodable>(completion: @escaping(T)->()) {
		
		guard let url = URL(string: stringArtistSearch) else {
			return
		}
		
		/*Alamofire.request(url).responseJSON { response in
			
			if let data = response.data {
				do {
					let parsedResponse = try JSONDecoder().decode(T.self, from: data)
					completion(parsedResponse)
				}catch {
					print("could not parse data")
				}
			}else {
				print("cannot retrieve data")
			}
		}*/
		
		URLSession.shared.dataTask(with: url) { (data, response, error) in
			
			guard let data = data else{
				return
			}
			do {
				let parsedResponse = try JSONDecoder().decode(T.self, from: data)
				completion(parsedResponse)
			}catch let jsonErr {
				print(jsonErr)
			}
		}.resume()
	}
	

}
