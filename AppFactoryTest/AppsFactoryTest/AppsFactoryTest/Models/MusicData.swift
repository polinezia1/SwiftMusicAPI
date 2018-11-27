//
//  MusicData.swift
//  AppsFactoryTest
//
//  Created by suricat on 03.11.18.
//  Copyright © 2018 suricat. All rights reserved.
//

import Foundation
import ObjectMapper

enum Size: String {
	case extralarge = "extralarge"
	case large = "large"
	case medium = "medium"
	case mega = "mega"
	case small = "small"
}

struct MusicData: Mappable {
    
    var artists : [Artist]?
    var albums : [Album]?
    var details : Album?
    
    init?(map: Map) {
    }
    
    mutating func mapping(map: Map) {
        
        artists <- map["results.artistmatches.artist"]
        albums <- map["topalbums.album"]
        details <- map["album"]
    }
    
    struct Artist: Mappable {
        
        var name: String?
        var imageList: [Image]?
        
        init?(map: Map) {
        }
        
        
        mutating func mapping(map: Map) {
            
            name <- map["name"]
            imageList <- map["image"]
        }
    }
    
    struct Image: Mappable {
        
        var text : String?
        var size : Size?
        var album : Album?
		
        init?(map: Map) {
    
        }
        
        mutating func mapping(map: Map) {
            
            text <- map["#text"]
			size <- map["size"]
        }
    }
    
    struct Album : Mappable {
        
        var uniqueId : String?
        var name : String?
        var artistName : String?
        var imageList : [Image]?
        var tracks : [Track]?
        
        init?(map: Map) {
            
        }
        
        mutating func mapping(map: Map) {
            
            uniqueId <- map["mbid"]
            name <- map["name"]
            artistName <- map["artist.name"]
            imageList <- map["image"]
            tracks <- map["tracks.track"]
        }
    }
    
    struct Track : Mappable {
        
        var name : String?
        
        init?(map: Map) {
            
        }
        
        mutating func mapping(map: Map) {
            
            name <- map["name"]
        }
    }
    
}
