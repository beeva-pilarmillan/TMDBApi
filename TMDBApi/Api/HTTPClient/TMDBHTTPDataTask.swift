//
//  TMDBHTTPDataTask.swift
//  TheMovieDBClient
//
//  Created by Pilar Millán on 26/12/16.
//  Copyright © 2016 BEEVA. All rights reserved.
//

import Foundation

typealias TMDBHTTPTaskCompletionHandler = (_ result: TMDBHTTPOperationResult) -> Void

enum TMDBHTTPTaskType {
    case Data
    case Image
}

protocol TMDBHTTPTask {
    func execute(withRequest request: URLRequest, session: URLSession, completionHandler: @escaping TMDBHTTPTaskCompletionHandler)
}

class TMDBHTTPTaskFactory {
    
    static func task(forType type: TMDBHTTPTaskType) -> TMDBHTTPTask {
        switch type {
        case .Data:
            return TMDBHTTPDataTask()
        case .Image:
            return TMDBHTTPImageTask()
        }
    }
}

class TMDBHTTPDataTask: TMDBHTTPTask {
    
    func execute(withRequest request: URLRequest, session: URLSession, completionHandler: @escaping TMDBHTTPTaskCompletionHandler) {
        
        session.dataTask(with: request) { (data, response, error) in
            
            if let error = error {
                completionHandler(.Failure(error: error))
            } else {
                completionHandler(.Success(httpResponse: response as! HTTPURLResponse?, data: data))
            }
        }.resume()
    }
}

class TMDBHTTPImageTask: TMDBHTTPTask {
    
    func execute(withRequest request: URLRequest, session: URLSession, completionHandler: @escaping TMDBHTTPTaskCompletionHandler) {
    
        session.downloadTask(with: request) { (url, response, error) in
            
            if let error = error {
                completionHandler(.Failure(error: error))
            } else {
                var data: Data?
                if let url = url {
                   
                    do {
                        try data = Data(contentsOf: url)
                    } catch _ {}
                }
                completionHandler(.Success(httpResponse: response as! HTTPURLResponse?, data: data))
            }
        }.resume()
    }
}

