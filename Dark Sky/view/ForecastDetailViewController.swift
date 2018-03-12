//
//  ForecastDetailViewController.swift
//  Dark Sky
//
//  Created by Tony Albor on 3/11/18.
//  Copyright © 2018 Tony Albor. All rights reserved.
//

import UIKit

class ForecastDetailViewController: UIViewController, NibIdentifiable {
    
    @IBOutlet private weak var icon: UIImageView!
    @IBOutlet private weak var day: UILabel!
    @IBOutlet private weak var summary: UILabel!
    @IBOutlet private weak var high: UILabel!
    @IBOutlet private weak var low: UILabel!
    
    private let viewModel: ForecastViewModel
    
    init(viewModel: ForecastViewModel) {
        self.viewModel = viewModel
        super.init(nibName: ForecastDetailViewController.nibName, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        icon.image = viewModel.icon
        day.text = viewModel.day
        summary.text = viewModel.summary
        high.text = "High: " + viewModel.high
        low.text = "Low: " + viewModel.low
    }
}
