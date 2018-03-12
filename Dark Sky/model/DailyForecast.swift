//
//  DailyForecast.swift
//  Dark Sky
//
//  Created by Tony Albor on 3/8/18.
//  Copyright © 2018 Tony Albor. All rights reserved.
//

import Foundation
import UIKit

struct DailyForecast {
    
    enum Icon: String {
        case clearDay = "clear-day"
        case clearNight = "clear-night"
        case rain
        case snow
        case sleet
        case wind
        case fog
        case cloudy
        case partlyCloudyDay = "partly-cloudy-day"
        case partlyCloudyNight = "partly-cloudy-night"
        
        func image() -> UIImage {
            return UIImage(named: rawValue)!
        }
    }
    
    let summary: String
    let time: TimeInterval
    let icon: Icon
    let temperatureLow: Double
    let temperatureHigh: Double
}

extension DailyForecast {
    init?(json: Json) {
        guard let summary = json["summary"] as? String,
            let time = json["time"] as? TimeInterval,
            let iconString = json["icon"] as? String,
            let low = json["temperatureLow"] as? Double,
            let high = json["temperatureHigh"] as? Double else {
                return nil
        }
        
        self = DailyForecast(
            summary: summary,
            time: time,
            icon: Icon(rawValue: iconString) ?? .clearDay,
            temperatureLow: low,
            temperatureHigh: high
        )
    }
}

extension DailyForecast: Equatable {}
func ==(lhs: DailyForecast, rhs: DailyForecast) -> Bool {
    return lhs.summary == rhs.summary &&
        lhs.time == rhs.time &&
        lhs.icon == rhs.icon &&
        lhs.temperatureLow == rhs.temperatureLow &&
        lhs.temperatureHigh == rhs.temperatureHigh
}
