//
//  Network.swift
//  Dark Sky
//
//  Created by Tony Albor on 3/8/18.
//  Copyright © 2018 Tony Albor. All rights reserved.
//

import RxAlamofire
import Alamofire
import RxSwift

typealias Json = [String: Any]

protocol APIRequest: URLRequestConvertible {
    var method: HTTPMethod { get }
    var urlString: String { get }
}

struct AlamofireRequest: APIRequest {
    
    let method: HTTPMethod
    let urlString: String
    
    func asURLRequest() throws -> URLRequest {
        return try URLRequest(url: urlString, method: method)
    }
}

protocol Network {
    func requestJson(_ request: APIRequest) -> Observable<Json>
}

struct AlamofireNetwork: Network {
    func requestJson(_ request: APIRequest) -> Observable<Json> {
        return RxAlamofire.json(request.method, request.urlString)
            .map { json -> Json in
                if let json = json as? Json {
                    return json
                }
                
                print("Error receiving json response: \(request.method) \(request.urlString)")
                
                return [:]
        }
    }
}
