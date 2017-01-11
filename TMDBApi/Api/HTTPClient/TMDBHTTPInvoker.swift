//
//  TMDBHTTPInvoker.swift
//  TheMovieDBClient
//
//  Created by Pilar Millán on 26/12/16.
//  Copyright © 2016 BEEVA. All rights reserved.
//

import Foundation

typealias TMDBHTTPInvokerCompletionHandler = (_ operationResult: TMDBHTTPOperationResult) -> Void

protocol TMDBHTTPInvoker {
    func newOperation(ofTaskType taskType: TMDBHTTPTaskType, withRequest request: URLRequest?) -> TMDBHTTPOperation?
}

class TMDBHTTPInvokerImpl {
    
    internal let urlSession: URLSession
    private let queue: OperationQueue
    
    init(urlSession: URLSession, queue: OperationQueue = OperationQueue()) {
        self.queue = queue
        self.urlSession = urlSession
    }
    
    func invoke(operation: TMDBHTTPOperationImpl, completionHandler: @escaping TMDBHTTPInvokerCompletionHandler) {
        
        weak var weakOperation = operation
        
        operation.completionBlock = {
            if let op = weakOperation {
                completionHandler(op.result)
            }
        }
        
        self.queue.addOperation(operation)
    }
}

extension TMDBHTTPInvokerImpl: TMDBHTTPInvoker {
    
    func newOperation(ofTaskType taskType: TMDBHTTPTaskType, withRequest request: URLRequest?) -> TMDBHTTPOperation? {
        
        guard let request = request else {
            return nil
        }
        
        return TMDBHTTPOperationImpl(taskType: taskType, request: request, urlSession: urlSession, invoker: self)
    }
}
