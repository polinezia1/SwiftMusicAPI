//
//  WeatherModel.swift
//  Generic
//
//  Created by suricat on 14.11.18.
//  Copyright © 2018 suricat. All rights reserved.
//

import Foundation
import UIKit

struct WeatherForecast : Codable {
	
	var location: String?
	var daysForecast: [DayForecast]?
	
	enum CodingKeys: String, CodingKey {
		case location
		case daysForecast = "three_day_forecast"
	}
	
	struct DayForecast: Codable {
		var conditions: String?
		var day: String?
		var temperature: Int?
		
		enum CodingKeys: String, CodingKey {
			case conditions
			case day
			case temperature
		}
	}

}


