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
