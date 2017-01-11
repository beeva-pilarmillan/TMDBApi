//
//  JSONParser.swift
//  TheMovieDBClient
//
//  Created by Pilar Millán on 27/12/16.
//  Copyright © 2016 BEEVA. All rights reserved.
//

import Foundation

struct JSONParser {
    
    var data: Data
    
    init(_ data: Data) {
        self.data = data
    }
    
    func parse() throws -> Any? {
        
        var error: NSError?
        let result = JSON(data: data, options: .allowFragments, error: &error)
        
        if error != nil {
            throw error!
        }
        
        return result
    }
}
