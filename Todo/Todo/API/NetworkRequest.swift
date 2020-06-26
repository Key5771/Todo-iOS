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
    
    func requestTodo(api: API, method: Alamofire.HTTPMethod, parameters: Todo? = nil, completion handler: @escaping (Error?) -> Void) {
        AF.request(baseUrl+api.rawValue, method: method, parameters: parameters, encoder: JSONParameterEncoder.default).response { (response) in
            switch response.result {
            case .success(_):
                handler(nil)
            case .failure(let err):
                print("Error getting POST: \(err)")
            }
        }
    }
    
}
