//
//  TMDBHTTPRequest.swift
//  TheMovieDBClient
//
//  Created by Pilar Millán on 27/12/16.
//  Copyright © 2016 BEEVA. All rights reserved.
//

import Foundation

typealias TMDBHTTPRequest = URLRequest

extension URLRequest {

    mutating func GET() {
        httpMethod = "GET"
    }
    
    mutating func POST() {
        httpMethod = "POST"
    }
    
    mutating func PUT() {
        httpMethod = "PUT"
    }
    
    mutating func DELETE() {
        httpMethod = "DELETE"
    }
    
    mutating func JSON(body: Data? = nil) {
        let value = "application/json"
        setValue(value, forHTTPHeaderField: "Accept")
        setValue(value, forHTTPHeaderField: "Content-Type")
        httpBody = body
    }
    
    mutating func addQueryParams(params: [URLQueryItem]) {
        
        if let url = url, let components = NSURLComponents(url: url, resolvingAgainstBaseURL: false) {
            
            var allQueryItems = params
            
            if let queryItems = components.queryItems {
                allQueryItems.append(contentsOf: queryItems)
            }
            
            components.queryItems = allQueryItems
            self.url = components.url
        }
    }
}

extension String {
    
    func stringByReplacingPlaceholders(placeholders: [String : String]) -> String {
        
        var result = self

        for key in placeholders.keys {
            
            if let replacement = placeholders[key] {
                result = result.replacingOccurrences(of: key, with: replacement)
            }
        }
        
        return result
    }
}
