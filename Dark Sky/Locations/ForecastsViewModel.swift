//
//  ForecastsViewModel.swift
//  Dark Sky
//
//  Created by Tony Albor on 3/8/18.
//  Copyright © 2018 Tony Albor. All rights reserved.
//

import CoreLocation
import RxCocoa
import RxSwift

typealias Location = CLLocationCoordinate2D

protocol ViewModel {
    associatedtype Input
    associatedtype Output
    
    func transform(input: Input) -> Output
}

class ForecastsViewModel: ViewModel {
    
    private let locationManager: LocationManager
    private let forecastService: ForecastService
    
    init(locationManager: LocationManager, forecastService: ForecastService) {
        self.locationManager = locationManager
        self.forecastService = forecastService
    }
    
    struct Input {
        let requestAccess: Driver<Void>
    }
    
    struct Output {
        let permissionsButtonEnabled: Driver<Bool>
        let forecasts: Driver<[DailyForecast]>
    }
    
    func transform(input: Input) -> Output {
        
        let buttonEnabled = Driver.merge(
            locationManager.isEnabled()
                .map { !$0 }
                .asDriver(onErrorJustReturn: true),
            input.requestAccess
                .do(onNext: locationManager.requestAccess)
                .map { false }
        )
        
        let forecasts = locationManager.currentCoordinates()
            .filter { $0 != nil }
            .map { $0! }
            .flatMap(forecastService.getDailyForecast)
            .asDriver(onErrorJustReturn: [])
        
        return Output(permissionsButtonEnabled: buttonEnabled, forecasts: forecasts)
    }
}
