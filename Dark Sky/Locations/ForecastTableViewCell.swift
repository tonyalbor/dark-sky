//
//  ForecastTableViewCell.swift
//  Dark Sky
//
//  Created by Tony Albor on 3/8/18.
//  Copyright © 2018 Tony Albor. All rights reserved.
//

import UIKit

protocol Nib {
    static var nib: UINib { get }
}

protocol ReuseIdentifiable {
    static var reuseIdentifier: String { get }
}

extension ReuseIdentifiable where Self: UITableViewCell {
    static var reuseIdentifier: String {
        return String(describing: self)
    }
}

protocol ReusableCell: Nib, ReuseIdentifiable {}

extension ReusableCell where Self: UITableViewCell {
    static var nib: UINib {
        return UINib(nibName: reuseIdentifier, bundle: nil)
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
        self = ForecastViewModel(icon: UIImage(), day: "", high: "High: \(forecast.temperatureHigh)"
            , low: "Low: \(forecast.temperatureLow)")
    }
}

extension UITableView {
    func registerCell<Cell: UITableViewCell>(_: Cell.Type = Cell.self) where Cell: ReusableCell {
        register(Cell.nib, forCellReuseIdentifier: Cell.reuseIdentifier)
    }
    
    func dequeueReusableCell<Cell: UITableViewCell>(_: Cell.Type = Cell.self) -> Cell where Cell: ReusableCell {
        return dequeueReusableCell(withIdentifier: Cell.reuseIdentifier) as! Cell
    }
}

class ForecastTableViewCell: UITableViewCell, ReusableCell {
    
    @IBOutlet private weak var icon: UIImageView!
    @IBOutlet private weak var day: UILabel!
    @IBOutlet private weak var high: UILabel!
    @IBOutlet private weak var low: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
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
