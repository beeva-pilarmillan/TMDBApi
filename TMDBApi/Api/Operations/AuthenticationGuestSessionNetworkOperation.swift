//
//  AuthenticationGuestSessionNetworkOperation.swift
//  TheMovieDBClient
//
//  Created by Pilar Millán on 7/1/17.
//  Copyright © 2017 BEEVA. All rights reserved.
//

import Foundation

class AuthenticationGuestSessionNetworkOperation: JSONNetworkOperation {

    var guestSessionData: GuestSessionData?
    
    override func prepareRequest() -> TMDBHTTPRequest? {
        guard var request = super.prepareRequest() else {
            return nil
        }
        
        request.GET()
        request.JSON()
        request.addQueryParams(params: queryParams)
        return request
    }
    
    override func getEndpoint() -> String {
        return "/authentication/guest_session/new"
    }
    
    override func finish() {
        
        guard let json = self.parsedData as? JSON else {
            return
        }
        
        print("Authentication guest session new: \(json)")

        if json["success"].boolValue {
            guestSessionData = GuestSessionData(json: json)
        }
    }
}
