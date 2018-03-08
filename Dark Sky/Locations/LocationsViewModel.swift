//
//  LocationsViewModel.swift
//  Dark Sky
//
//  Created by Tony Albor on 3/8/18.
//  Copyright © 2018 Tony Albor. All rights reserved.
//

import RxCocoa
import RxSwift

protocol ViewModel {
    associatedtype Input
    associatedtype Output
    
    func transform(input: Input) -> Output
}

class LocationsViewModel: ViewModel {
    
    private let locationManager: LocationManager
    
    init(locationManager: LocationManager) {
        self.locationManager = locationManager
    }
    
    struct Input {
        let requestAccess: Driver<Void>
    }
    
    struct Output {
        let permissionsButtonEnabled: Driver<Bool>
        let locations: Driver<[Location]>
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
        
        let locations = locationManager.currentCoordinates()
            .map { (coordinate) -> [Location] in
                guard let coordinate = coordinate else {
                    print("no good")
                    return []
                }
                print(coordinate)
                return []
            }
            .asDriver(onErrorJustReturn: [])
        
        return Output(permissionsButtonEnabled: buttonEnabled, locations: locations)
    }
}

struct Location {
    
}
