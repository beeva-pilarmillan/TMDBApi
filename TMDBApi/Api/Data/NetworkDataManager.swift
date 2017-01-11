//
//  NetworkDataManager.swift
//  TheMovieDBClient
//
//  Created by Pilar Millán on 27/12/16.
//  Copyright © 2016 BEEVA. All rights reserved.
//

import Foundation

protocol NetworkDataManager {
    func execute(operation: NetworkOperation, completionHandler: @escaping () -> Void)
}

class NetworkDataManagerImpl {
    
    fileprivate var invoker: TMDBHTTPInvoker
    static let sharedInstance: NetworkDataManager = {
        print("Creating NetworkDataManager instance")
        let invoker = TMDBHTTPInvokerImpl(urlSession: URLSession(configuration: .default))
        return NetworkDataManagerImpl(invoker: invoker)
    }()

    init(invoker: TMDBHTTPInvoker) {
        self.invoker = invoker
    }
}

extension NetworkDataManagerImpl: NetworkDataManager {
    
    final func execute(operation: NetworkOperation, completionHandler: @escaping () -> Void) {
        
        if let type = operation.type,
            let httpOperation = invoker.newOperation(ofTaskType: type, withRequest: prepareRequest(operation: operation)) {
            
            operation.startTime = currentTime
            
            httpOperation.execute { [unowned self] (result) in
                
                operation.endTime = self.currentTime
                
                switch result {
                case .Success(let httpResponse, let data):
                    operation.httpResponse = httpResponse
                    operation.data = data
                case .Failure(let error):
                    operation.error = error
                default:
                    operation.error = self.getError(code: .Unknown, description: "Unknown error while invoking")
                }
                
                self.processOperation(operation: operation, completionHandler)
            }
            
        } else {
            
            operation.error = getError(code: .Operation, description: "Operation error")
            finalize(operation: operation, completionHandler: completionHandler)
        }
    }
}

// MARK: Parse
fileprivate extension NetworkDataManagerImpl {
    
    func parse(operation: NetworkOperation) {
        
        guard operation.error == nil,
            let data = operation.data, let response = operation.httpResponse else {
            return
        }
        
        if let parser = operation.getParser(data: data) as? JSONParser {
            
            do {
                
                if let parsedData = try parser.parse() {
                    operation.parsedData = parsedData
                    operation.response = operation.prepareResponse(parsedData: parsedData, response: response)
                    operation.error = operation.response?.error
                }
                
            } catch let exception as NSError {
                
                operation.error = exception
                
            } catch {
                
                operation.error = getError(code: .Parsing, description: "Unknown error.")
            }
        }
    }
}

// MARK: Response
fileprivate extension NetworkDataManagerImpl {
    
    func processOperation(operation: NetworkOperation, _ completionHandler: @escaping () -> Void) {
        
        parse(operation: operation)
        
        finalize(operation: operation, completionHandler: completionHandler)
        logHTTPResponse(response: operation.httpResponse, data: operation.data, error: operation.error, file: String(describing: type(of: operation)))
    }
}

// MARK: Finalization
fileprivate extension NetworkDataManagerImpl {
    
    func finalize(operation: NetworkOperation, completionHandler: @escaping () -> Void) {
       
        operation.finish()

        DispatchQueue.main.async {
            completionHandler()
        }
    }
}

// MARK: Utils
fileprivate extension NetworkDataManagerImpl {
    
    func prepareRequest(operation: NetworkOperation) -> URLRequest? {
        
        guard let request = operation.prepareRequest() else {
            return nil
        }
        
        operation.request = request
        logHTTPRequest(request: request as URLRequest, file: String(describing: type(of: operation)))
        
        return request as URLRequest
    }
    
    func getError(code: NetworkDataManagerErrorCode, description: String?) -> Error {
        return NSError(
            domain: "NetworkDataManagerDomain",
            code: code.rawValue,
            userInfo: [NSLocalizedDescriptionKey : description ?? ""]
        )
    }
    
    var currentTime: TimeInterval {
        return Date.timeIntervalSinceReferenceDate
    }
}

// MARK: Constants
private enum NetworkDataManagerErrorCode: Int {
    case Unknown = -1
    case Operation
    case Parsing
}
