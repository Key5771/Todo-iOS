//
//  NetworkRequest.swift
//  Todo
//
//  Created by 김기현 on 2020/06/25.
//  Copyright © 2020 김기현. All rights reserved.
//

import Foundation
import Alamofire

class NetworkRequest {
    static let shared: NetworkRequest = NetworkRequest()
    let baseUrl = "http://localhost:8080/api"
    
    enum API: String {
        case getInfo = "/todo"
    }
    
    enum NetworkError: Error {
        case http404
    }
    
    func responseTodo<Response: Decodable>(api: API, method: Alamofire.HTTPMethod,
                 parameters: Parameters? = nil,
                 encoding: URLEncoding? = nil,
                 completion handler: @escaping (Response) -> Void) {
        
        AF.request(baseUrl+api.rawValue, method: method, parameters: parameters).responseDecodable(of: Response.self) { (response) in
            switch response.result {
            case .success(let obj):
                handler(obj)
            case .failure(let err):
                print("Failure Error: \(err)")
            }
        }
    }
    
    func request(api: API,
                 method: Alamofire.HTTPMethod,
                 parameters: Parameters? = nil,
                 completion handler: @escaping (Error?) -> Void) {
        
        AF.request(baseUrl+api.rawValue, method: method, parameters: parameters).response { (response) in
            if response.response?.statusCode == 200 {
                handler(nil)
            } else {
                handler(NetworkError.http404)
                print("StatusCode:\(String(describing: response.response?.statusCode)), RequestURL:\(String(describing:response.request?.url)), Headerr:\(String(describing:response.request?.httpBody))")
            }
        }
    }
}
