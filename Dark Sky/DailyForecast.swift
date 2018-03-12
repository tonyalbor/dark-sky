//
//  DailyForecast.swift
//  Dark Sky
//
//  Created by Tony Albor on 3/8/18.
//  Copyright © 2018 Tony Albor. All rights reserved.
//

import Foundation

struct DailyForecast {
    let summary: String
    let time: TimeInterval
    let icon: String
    let temperatureLow: Double
    let temperatureHigh: Double
}

extension DailyForecast {
    init?(json: Json) {
        guard let summary = json["summary"] as? String,
            let time = json["time"] as? TimeInterval,
            let icon = json["icon"] as? String,
            let low = json["temperatureLow"] as? Double,
            let high = json["temperatureHigh"] as? Double else {
                return nil
        }
        
        self = DailyForecast(
            summary: summary,
            time: time,
            icon: icon,
            temperatureLow: low,
            temperatureHigh: high
        )
    }
}
