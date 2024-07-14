//
//  NetworkService.swift
//  Movies
//
//  Created by Macbook on 10.07.2024.
//

import Foundation
import UIKit
import Alamofire

protocol NetworkServiceProtocol {
    func fetchData(for url: URL, completionHandler: @escaping (Data?) -> ())
}

struct NetworkService: NetworkServiceProtocol {
    
    let headers = HTTPHeaders([HTTPHeader(name: "accept", value: "application/json"),
                               HTTPHeader(name: "Authorization", value: "Bearer eyJhbGciOiJIUzI1NiJ9.eyJhdWQiOiJkZDQ0MGRjMzJiOWJlZTA2NzhiYTc0NDZkMWFjZDAzMyIsIm5iZiI6MTcyMDQ1MjYwOS4xMzE4MjksInN1YiI6IjY2ODZkNzg3OWU1MThkYjA1YjFiZTBjNSIsInNjb3BlcyI6WyJhcGlfcmVhZCJdLCJ2ZXJzaW9uIjoxfQ.qjEJ2L9fvnfkdm3xNAXYwHf12YqMtcOlgKOOSBHbQXY")])
    
    func fetchData(for url: URL, completionHandler: @escaping (Data?) -> ()) {
        AF.request(url, headers: headers).responseData { responseData in
            switch responseData.result {
                case .success(let value):
                    completionHandler(value)
                case .failure(let error):
                    print(error)
                }
        }
    }
}
