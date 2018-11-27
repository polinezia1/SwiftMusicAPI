//
//  Endoint.swift
//  AppleCoreData
//
//  Created by suricat on 12.11.18.
//  Copyright © 2018 suricat. All rights reserved.
//

import Foundation

protocol Endpoint {
    
    var baseUrl: String {get}
    var path: String {get}
}

extension Endpoint {
    
    var apiKey : String {
        return "api_key=7708cffb338819aca303ac49c683f910"
    }
    
    var url: URL? {
        guard let _baseUrlComponent = URLComponents(string: baseUrl) else {
            assertionFailure("please provide base url components")
            return nil
        }
        
        var components = _baseUrlComponent
        components.path = path
        //components.query = apiKey
        return components.url
    }
}
