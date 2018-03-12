//
//  ForecastTableViewCell.swift
//  Dark Sky
//
//  Created by Tony Albor on 3/8/18.
//  Copyright © 2018 Tony Albor. All rights reserved.
//

import UIKit

class ForecastTableViewCell: UITableViewCell, ReusableCell {
    
    @IBOutlet private weak var icon: UIImageView!
    @IBOutlet private weak var day: UILabel!
    @IBOutlet private weak var high: UILabel!
    @IBOutlet private weak var low: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        low.textColor = UIColor.black.withAlphaComponent(0.5)
    }
    
    var viewModel: ForecastViewModel? {
        didSet {
            icon.image = viewModel?.icon
            day.text = viewModel?.day
            high.text = viewModel?.high
            low.text = viewModel?.low
        }
    }
}

struct ForecastViewModel {
    let icon: UIImage
    let day: String
    let high: String
    let low: String
}

extension ForecastViewModel {
    init(forecast: DailyForecast) {
        let date = Date(timeIntervalSince1970: forecast.time)
        let day = ForecastViewModel.dayStringFromDate(date)
        let high = String(format: "%.0f", arguments: [forecast.temperatureHigh])
        let low = String(format: "%.0f", arguments: [forecast.temperatureLow])
        self = ForecastViewModel(
            icon: UIImage(),
            day: day,
            high: high,
            low: low
        )
    }
    
    private static func dayStringFromDate(_ date: Date) -> String {
        let day = Calendar.current.component(.weekday, from: date)
        switch day {
        case 1: return "Monday"
        case 2: return "Tuesday"
        case 3: return "Wednesday"
        case 4: return "Thursday"
        case 5: return "Friday"
        case 6: return "Saturday"
        case 7: return "Sunday"
        default: return ""
        }
    }
}
