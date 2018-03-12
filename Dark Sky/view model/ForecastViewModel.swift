//
//  ForecastViewModel.swift
//  Dark Sky
//
//  Created by Tony Albor on 3/11/18.
//  Copyright © 2018 Tony Albor. All rights reserved.
//

import UIKit

struct ForecastViewModel {
    let icon: UIImage
    let day: String
    let summary: String
    let high: String
    let low: String
}

extension ForecastViewModel {
    
    static var dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "EEEE"
        formatter.timeZone = .current
        return formatter
    }()
    
    init(forecast: DailyForecast) {
        let date = Date(timeIntervalSince1970: forecast.time)
        let day = ForecastViewModel.dateFormatter.string(from: date)
        let high = String(format: "%.0f", arguments: [forecast.temperatureHigh])
        let low = String(format: "%.0f", arguments: [forecast.temperatureLow])
        self = ForecastViewModel(
            icon: forecast.icon.image(),
            day: day,
            summary: forecast.summary,
            high: high,
            low: low
        )
    }
}
