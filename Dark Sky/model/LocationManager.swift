//
//  LocationPermissionsService.swift
//  Dark Sky
//
//  Created by Tony Albor on 3/7/18.
//  Copyright © 2018 Tony Albor. All rights reserved.
//

import RxSwift
import CoreLocation

protocol LocationManager {
    func isEnabled() -> Observable<Bool>
    func requestAccess()
    func currentCoordinates() -> Observable<CLLocationCoordinate2D?>
}

class CoreLocationManager: NSObject, LocationManager {
    
    private let manager: CLLocationManager
    private let isEnabledSubject: Variable<Bool> = Variable(false)
    private let currentLocationVariable: Variable<CLLocationCoordinate2D?> = Variable(nil)
    
    init(manager: CLLocationManager) {
        self.manager = manager
        super.init()
        self.manager.delegate = self
    }
    
    func isEnabled() -> Observable<Bool> {
        isEnabledSubject.value = CLLocationManager.locationServicesEnabled()
        return isEnabledSubject.asObservable()
    }
    
    func requestAccess() {
        manager.requestWhenInUseAuthorization()
    }
    
    func currentCoordinates() -> Observable<CLLocationCoordinate2D?> {
        return currentLocationVariable.asObservable()
    }
}

extension CoreLocationManager: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        currentLocationVariable.value = locations.last?.coordinate
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        let isNowEnabled = status == .authorizedWhenInUse
        isEnabledSubject.value = isNowEnabled
        
        if isNowEnabled {
            manager.startUpdatingLocation()
        }
    }
}
