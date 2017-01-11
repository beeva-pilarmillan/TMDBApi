//
//  TMDBHTTPOperation.swift
//  TheMovieDBClient
//
//  Created by Pilar Millán on 26/12/16.
//  Copyright © 2016 BEEVA. All rights reserved.
//

import Foundation

enum TMDBHTTPOperationResult {
    case Success(httpResponse: HTTPURLResponse?, data: Data?)
    case Failure(error: Error)
    case Unknown
}

protocol TMDBHTTPOperation {
    var request: URLRequest { get }
    var result: TMDBHTTPOperationResult { get }
    func execute(completionHandler: @escaping TMDBHTTPInvokerCompletionHandler)
    func cancel()
}

class TMDBHTTPOperationImpl: Operation {
    
    fileprivate let internalRequest: URLRequest
    fileprivate let urlSession: URLSession
    fileprivate(set) weak var invoker: TMDBHTTPInvokerImpl!
    fileprivate var internalResult: TMDBHTTPOperationResult = .Unknown
    fileprivate let taskType: TMDBHTTPTaskType
    
    init?(taskType: TMDBHTTPTaskType, request: URLRequest, urlSession: URLSession, invoker: TMDBHTTPInvokerImpl) {
        self.taskType = taskType
        self.internalRequest = request
        self.urlSession = urlSession
        self.invoker = invoker
        super.init()
        
        guard let url = request.url, url.absoluteString.hasPrefix("https") else {
            return nil
        }
    }
    
    private var operationExecuting: Bool = false
    private var operationFinished: Bool = false
    
    override var isAsynchronous: Bool {
        return true
    }
    
    override var isExecuting: Bool {
        get {
            return operationExecuting
        }
        set {
            if operationExecuting != newValue {
                willChangeValue(forKey: "isExecuting")
                operationExecuting = newValue
                didChangeValue(forKey: "isExecuting")
            }
        }
    }
    
    override var isFinished: Bool {
        get {
            return operationFinished
        }
        set {
            if operationFinished != newValue {
                willChangeValue(forKey: "isFinished")
                operationFinished = newValue
                didChangeValue(forKey: "isFinished")
            }
        }
    }
    
    override func start() {
        
        if isCancelled {
            isFinished = true
        } else {
            isExecuting = true
            
            TMDBHTTPTaskFactory.task(forType: taskType).execute(withRequest: internalRequest, session: urlSession, completionHandler: { [weak self] result in
                self?.internalResult = result
                self?.isFinished = true
            })
        }
    }
    
    override func cancel() {
        super.cancel()
        
        isFinished = true
        isExecuting = false
    }
}

extension TMDBHTTPOperationImpl: TMDBHTTPOperation {
   
    var request: URLRequest {
        return internalRequest
    }
    
    var result: TMDBHTTPOperationResult {
        return internalResult
    }
    
    func execute(completionHandler: @escaping TMDBHTTPInvokerCompletionHandler) {
        invoker.invoke(operation: self, completionHandler: completionHandler)
    }
}
