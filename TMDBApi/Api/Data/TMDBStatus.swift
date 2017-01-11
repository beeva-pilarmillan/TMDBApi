//
//  TMDBStatus.swift
//  TheMovieDBClient
//
//  Created by Pilar Millán on 27/12/16.
//  Copyright © 2016 BEEVA. All rights reserved.
//

import Foundation

struct TMDBStatus {
    let code: Int
    let message: String
    let success: Bool
}

extension TMDBStatus {
    
    static func parse(json: JSON) -> TMDBStatus? {
        
        guard !json.isEmpty else {
            return nil
        }
        
        return TMDBStatus(code: json["status_code"].intValue,
                          message: json["status_message"].stringValue,
                          success: json["success"].boolValue)
    }
}
