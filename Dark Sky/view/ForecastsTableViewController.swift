//
//  ForecastsTableViewController.swift
//  Dark Sky
//
//  Created by Tony Albor on 3/7/18.
//  Copyright © 2018 Tony Albor. All rights reserved.
//

import UIKit
import CoreLocation
import RxCocoa
import RxSwift

class ForecastsTableViewController: UITableViewController {
    
    private var viewModel: ForecastsViewModel!
    private let disposeBag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.viewModel = ForecastsViewModel(
            locationManager: LocationManager(manager: CLLocationManager()),
            forecastService: DarkSkyForecastService(network: AlamofireNetwork())
        )
        navigationItem.title = "Forecast"
        let permissionsButton = UIBarButtonItem()
        permissionsButton.title = "Request"
        tableView.registerCell(ForecastTableViewCell.self)
        tableView.rowHeight = 60
        bindViewModel(barButtonItem: permissionsButton)
    }
    
    private func bindViewModel(barButtonItem: UIBarButtonItem) {
        navigationItem.rightBarButtonItem = barButtonItem
        let input = ForecastsViewModel.Input(
            requestAccess: barButtonItem.rx.tap.asDriver()
        )
        
        let output = viewModel.transform(input: input)
        
        output.permissionsButtonEnabled
            .drive(barButtonItem.rx.isEnabled)
            .disposed(by: disposeBag)
        
        output.forecasts
            .drive(tableView.rx.items) { table, index, forecast in
                let cell = table.dequeueReusableCell(ForecastTableViewCell.self)
                cell.viewModel = ForecastViewModel(forecast: forecast)
                return cell
            }
            .disposed(by: disposeBag)
        
        tableView.rx.modelSelected(Forecast.self)
            .asDriver()
            .drive(onNext: { forecast in
                let detailViewModel = ForecastViewModel(forecast: forecast)
                let detail = ForecastDetailViewController(viewModel: detailViewModel)
                self.navigationController?.pushViewController(detail, animated: true)
            })
            .disposed(by: disposeBag)
    }
}
