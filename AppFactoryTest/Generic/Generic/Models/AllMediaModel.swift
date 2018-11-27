//
//  AllMediaModel.swift
//  Generic
//
//  Created by suricat on 14.11.18.
//  Copyright © 2018 suricat. All rights reserved.
//
//

import Foundation
import CoreData

struct MediaArtistSearch: Codable {
	let results: Results
}

struct Results: Codable {
	var artistmatches: Artistmatches?
	
	enum CodingKeys: String, CodingKey {
		case artistmatches
	}
}

struct Artistmatches: Codable {
	var artist: [Artist]?
}

struct Artist: Codable {
	var name, mbid: String?
	var image: [Image]?
	
}

extension CodingUserInfoKey {
	static let context = CodingUserInfoKey(rawValue: "context")
}

struct Image: Codable {
	let text: String
	let size: Size
	
	enum CodingKeys: String, CodingKey {
		case text = "#text"
		case size
	}
}

enum Size: String, Codable {
	case extralarge = "extralarge"
	case large = "large"
	case medium = "medium"
	case mega = "mega"
	case small = "small"
}
