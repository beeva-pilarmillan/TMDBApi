//
//  NetworkOperation.swift
//  TheMovieDBClient
//
//  Created by Pilar Millán on 7/1/17.
//  Copyright © 2017 BEEVA. All rights reserved.
//

import Foundation

class NetworkOperation {
    
    let apiConfiguration: TMDBApiConfiguration = TMDBApiConfigurationImpl()
    
    var request: TMDBHTTPRequest?
    var httpResponse: HTTPURLResponse?
    var response: TMDBResponse?
    var data: Data?
    var parsedData: Any?
    var error: Error?
    var startTime: TimeInterval = 0
    var endTime: TimeInterval = 0
    var responseTime: TimeInterval {
        return endTime - startTime
    }
    
    var type: TMDBHTTPTaskType? {
        return .Data
    }
    
    var uriRoot: String {
        return ""
    }
    
    func prepareRequest() -> TMDBHTTPRequest? {
        guard let url = URL(string: url()) else {
            return nil
        }
        return TMDBHTTPRequest(url: url)
    }
    
    func prepareResponse(parsedData: Any, response: HTTPURLResponse) -> TMDBResponse? {
        return nil
    }
    
    func getParser(data: Data) -> Any? {
        return nil
    }
    
    func getEndpoint() -> String {
        return "" //Children have to implement it
    }
    
    func url() -> String {
        return uriRoot + getEndpoint()
    }
    
    func finish() {

    }
}
