//
//  LocationsTableViewController.swift
//  Dark Sky
//
//  Created by Tony Albor on 3/7/18.
//  Copyright © 2018 Tony Albor. All rights reserved.
//

import UIKit
import CoreLocation
import RxCocoa
import RxSwift

class LocationsTableViewController: UITableViewController {
    
    private var viewModel: LocationsViewModel!
    private let disposeBag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.viewModel = LocationsViewModel(locationManager: LocationManager(manager: CLLocationManager()))
        let permissionsButton = UIBarButtonItem()
        permissionsButton.title = "Request"
        bindViewModel(barButtonItem: permissionsButton)
    }
    
    private func bindViewModel(barButtonItem: UIBarButtonItem) {
        navigationItem.rightBarButtonItem = barButtonItem
        let input = LocationsViewModel.Input(requestAccess: barButtonItem.rx.tap.asDriver())
        
        let output = viewModel.transform(input: input)
        
        output.permissionsButtonEnabled
            .drive(barButtonItem.rx.isEnabled)
            .disposed(by: disposeBag)
        
        
        output.locations
            .drive(tableView.rx.items) { table, index, element in
                return table.dequeueReusableCell(withIdentifier: "")!
            }
            .disposed(by: disposeBag)
        
    }
}
