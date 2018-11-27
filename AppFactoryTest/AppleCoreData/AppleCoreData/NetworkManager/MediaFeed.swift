//
//  Endpoint.swift
//  AppleCoreData
//
//  Created by suricat on 11.11.18.
//  Copyright © 2018 suricat. All rights reserved.
//

import Foundation

enum MediaFeed : Endpoint{
    
    case artistAlbums
    case albumDetails
    case searchArtists
}

extension MediaFeed {
    
    var baseUrl : String {
        return "http://ws.audioscrobbler.com"
    }
    
    var path : String {
        
        switch self {
        case .artistAlbums:
            return ""
        case .albumDetails:
            return ""
        case .searchArtists:
            return "/2.0/?method=artist.search"
        }
    }
}

