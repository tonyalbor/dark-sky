//
//  ForecastsViewModelTests.swift
//  Dark SkyTests
//
//  Created by Tony Albor on 3/11/18.
//  Copyright © 2018 Tony Albor. All rights reserved.
//

import XCTest
import CoreLocation
import RxSwift
import RxCocoa
@testable import Dark_Sky

class MockLocationManager: LocationPermissionsService {
    private let enabled: Bool
    init(enabled: Bool) {
        self.enabled = enabled
    }
    func isEnabled() -> Observable<Bool> {
        return .just(enabled)
    }
    func requestAccess() {}
    func currentCoordinates() -> Observable<CLLocationCoordinate2D?> {
        return .just(nil)
    }
}

class MockForecastService: ForecastService {
    private let forecasts: [Forecast]
    init(forecasts: [Forecast]) {
        self.forecasts = forecasts
    }
    func getForecasts(location: Location) -> Observable<[Forecast]> {
        return .just(forecasts)
    }
}

class ForecastsViewModelTests: XCTestCase {
    
    private var disposeBag = DisposeBag()
    private let forecasts = [
        Forecast( summary: "1", time: 1, icon: .clearDay, temperatureLow: 1, temperatureHigh: 1),
        Forecast( summary: "2", time: 2, icon: .clearNight, temperatureLow: 2, temperatureHigh: 2),
        Forecast( summary: "3", time: 3, icon: .rain, temperatureLow: 3, temperatureHigh: 3),
    ]
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
        disposeBag = DisposeBag()
    }
    
    func testButtonEnabled_LocationDisabled_True() {
        // Given
        let location = MockLocationManager(enabled: false)
        let forecastService = MockForecastService(forecasts: [])
        let viewModel = ForecastsViewModel(locationManager: location, forecastService: forecastService)
        
        // When
        let requestAccess: Driver<Void> = Driver.empty()
        let input = ForecastsViewModel.Input(requestAccess: requestAccess)
        let output = viewModel.transform(input: input)
        
        // Then
        output.permissionsButtonEnabled
            .drive(onNext: { (enabled) in
                XCTAssert(enabled)
            })
            .disposed(by: disposeBag)
    }
    
    func testButtonEnabled_LocationEnabled_False() {
        // Given
        let location = MockLocationManager(enabled: true)
        let forecastService = MockForecastService(forecasts: [])
        let viewModel = ForecastsViewModel(locationManager: location, forecastService: forecastService)
        
        // When
        let requestAccess: Driver<Void> = Driver.empty()
        let input = ForecastsViewModel.Input(requestAccess: requestAccess)
        let output = viewModel.transform(input: input)
        
        // Then
        output.permissionsButtonEnabled
            .drive(onNext: { (enabled) in
                XCTAssertFalse(enabled)
            })
            .disposed(by: disposeBag)
    }
    
    func testForecasts_LocationDisabled_NoForecasts() {
        // Given
        let location = MockLocationManager(enabled: false)
        let forecastService = MockForecastService(forecasts: forecasts)
        let viewModel = ForecastsViewModel(locationManager: location, forecastService: forecastService)
        
        // When
        let requestAccess: Driver<Void> = Driver.empty()
        let input = ForecastsViewModel.Input(requestAccess: requestAccess)
        let output = viewModel.transform(input: input)
        
        // Then
        output.forecasts
            .drive(onNext: { (outputForecasts) in
                XCTAssertEqual(0, outputForecasts.count)
            })
            .disposed(by: disposeBag)
    }
    
    func testForecasts_LocationEnabled_Forecasts() {
        // Given
        let location = MockLocationManager(enabled: false)
        let forecastService = MockForecastService(forecasts: forecasts)
        let viewModel = ForecastsViewModel(locationManager: location, forecastService: forecastService)
        
        // When
        let requestAccess: Driver<Void> = Driver.empty()
        let input = ForecastsViewModel.Input(requestAccess: requestAccess)
        let output = viewModel.transform(input: input)
        
        // Then
        output.forecasts
            .drive(onNext: { [unowned self] (outputForecasts) in
                XCTAssertEqual(self.forecasts, outputForecasts)
            })
            .disposed(by: disposeBag)
    }
}
