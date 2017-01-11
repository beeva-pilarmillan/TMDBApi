//
//  TMDBDataSource.swift
//  TheMovieDBClient
//
//  Created by Pilar Millán on 7/1/17.
//  Copyright © 2017 BEEVA. All rights reserved.
//

import Foundation

protocol TMDBDataSource {
    var dataManager: NetworkDataManager { get set }
}

extension TMDBDataSource {
    
    public func getImage(withPath path: String, completionHandler: @escaping (Data?, Error?) -> Void) {
        
        let operation = FileNetworkOperation(filePath: path)
        
        dataManager.execute(operation: operation) {
            completionHandler(operation.data, operation.error)
        }
    }
}

internal extension TMDBDataSource {
    
    func getGuestAuthentication(completionHandler: @escaping (_ sessionData: GuestSessionData?, _ error: Error?) -> Void) {
        
        let operation = AuthenticationGuestSessionNetworkOperation()
        
        dataManager.execute(operation: operation) {
            completionHandler(operation.guestSessionData, operation.error)
        }
    }
}
