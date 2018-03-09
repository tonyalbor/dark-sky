//
//  ForecastService.swift
//  Dark Sky
//
//  Created by Tony Albor on 3/8/18.
//  Copyright © 2018 Tony Albor. All rights reserved.
//

import RxCocoa
import RxSwift

protocol ForecastService {
    func getDailyForecast(location: Location) -> Observable<[DailyForecast]>
}

class DarkSkyForecastService: ForecastService {
    
    private let network: Network
    
    init(network: Network) {
        self.network = network
    }
    
    func getDailyForecast(location: Location) -> Observable<[DailyForecast]> {
        let request = AlamofireRequest(
            method: .get,
            urlString: "https://api.darksky.net/forecast/4b226a790270af7a2e8ca54f80289b83/\(location.latitude),\(location.longitude)"
        )
        
        return network.requestJson(request)
            .map { json in
                guard let dailyJson = json["daily"] as? Json, let data = dailyJson["data"] as? [Json] else {
                    return []
                }
                return data.flatMap(DailyForecast.init)
            }
    }
}
