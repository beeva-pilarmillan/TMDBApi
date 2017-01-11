//
//  NetworkDataManager+Console.swift
//  TheMovieDBClient
//
//  Created by Pilar Millán on 27/12/16.
//  Copyright © 2016 BEEVA. All rights reserved.
//

import Foundation

extension NetworkDataManagerImpl {
    
    func logHTTPRequest(request: URLRequest?, file: String) {
        
        if let req = request {
            
            var stringToLog: String = ""
            
            stringToLog += "\n" + "URL: \(req.url?.absoluteString ?? "")"
            stringToLog += "\n" + "HTTP METHOD: \(req.httpMethod ?? "")"
            if let data = req.httpBody, let dataString = String(data: data, encoding: String.Encoding.utf8) {
                stringToLog += "\n" + "BODY: \(dataString)"
            }
            
            print("<NETWORK:REQUEST>\n\(stringToLog)" )
        }
    }
    
    func logHTTPResponse(response: HTTPURLResponse?, data: Data?, error: Error?, file: String) {
        
        let log: (String) -> Void = { string in
            
            let isError = error != nil
            
            if !string.isEmpty {
                if isError {
                    print("<NETWORK:KO>\n\(string)")
                } else {
                    print("<NETWORK:OK>\n\(string)")
                }
            }
        }
        
        var stringToLog: String = ""
        
        if let res = response {
            
            stringToLog += "\n" + "URL: \(res.url?.absoluteString ?? "")"
            stringToLog += "\n" + "STATUS CODE: \(res.statusCode)"
            stringToLog += "\n" + "HEADERS: \(res.allHeaderFields.debugDescription )"
            
            if let data = data, let dataString = String(data: data, encoding: String.Encoding.utf8) {
                stringToLog += "\n" + "DATA:\n\n\(dataString)\n\n"
            }
        }
        
        if let error = error {
            stringToLog += "\n" + "ERROR: <\(error._domain):\(error._code)> \(error.localizedDescription)"
        }
        
        log(stringToLog)
    }
}
