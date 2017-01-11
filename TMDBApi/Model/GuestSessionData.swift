//
//  GuestSessionData.swift
//  TheMovieDBClient
//
//  Created by Pilar Millán on 7/1/17.
//  Copyright © 2017 BEEVA. All rights reserved.
//

import Foundation

public struct GuestSessionData {
    public let sessionId: String
    public let expiresAt: String
    
    init?(json: JSON) {
        
        guard let sessionId = json["guest_session_id"].string else {
            return nil
        }
        
        self.sessionId = sessionId
        expiresAt = json["expires_at"].stringValue
    }
}
