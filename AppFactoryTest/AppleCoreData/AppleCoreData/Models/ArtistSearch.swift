//
//  MediaModel.swift
//  AppleCoreData
//
//  Created by suricat on 10.11.18.
//  Copyright © 2018 suricat. All rights reserved.
//

import UIKit
import Foundation
import CoreData

struct ArtistSearch: Codable {
        
		//var artists: [Artist]?
		var searchTerm: String?
		
    	enum CodingKeys: String, CodingKey {
			//case artists = "results.artistmatches.artist"
			case searchTerm = "results.openSearch:Query:.searchTerms"
		}
}

    struct Artist: Codable {
		
		var name: String?
		var url: String?
		
		enum CodingKeys: String, CodingKey {
			case name
			case url
		}
	}
		
		
		/*
        
        @NSManaged var  name : String?
        @NSManaged var imageList: [ImagesList]
        
        struct ImageList: NSManagedObject, Codable {
            
            enum CodingKeys: String, CodingKey {
                case textUrl = "#text"
                case size
            }
            
            @NSManaged var textUrl: String
            @NSManaged var size: String
        }
 
        
        // MARK - Decodable
        required convenience init(from decoder: Decoder) throws {
			
			guard
				let userInfoKey = CodingUserInfoKey.context,
				let currentManagedContext = decoder.userInfo[userInfoKey] as? NSManagedObjectContext else {
                	fatalError()
            }
	
            guard let entity = NSEntityDescription.entity(forEntityName: "Artist", in: currentManagedContext) else { fatalError() }
			self.init(entity: entity, insertInto: currentManagedContext)
            
			let container = try decoder.container(keyedBy: CodingKeys.self)
			self.name = try container.decodeIfPresent(String.self, forKey: .name)
        }
        
        // MARK - Encodable
        func encode(to encoder: Encoder) throws {

        }
}
*/
