//
//  ForecastViewModelTests.swift
//  Dark SkyTests
//
//  Created by Tony Albor on 3/11/18.
//  Copyright © 2018 Tony Albor. All rights reserved.
//

import XCTest
@testable import Dark_Sky

class ForecastViewModelTests: XCTestCase {
    
    let sundayTimestamp: TimeInterval = 1520836086
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    func testInitWithForecast() {
        // Given
        let forecast = Forecast(
            summary: "Nice",
            time: sundayTimestamp,
            icon: .clearDay,
            temperatureLow: 44.21,
            temperatureHigh: 87.44
        )
        
        // When
        let viewModel = ForecastViewModel(forecast: forecast)
        
        // Then
        XCTAssertEqual(Forecast.Icon.clearDay.image(), viewModel.icon)
        XCTAssertEqual("Sunday", viewModel.day)
        XCTAssertEqual("Nice", viewModel.summary)
        XCTAssertEqual("87", viewModel.high)
        XCTAssertEqual("44", viewModel.low)
    }
}
