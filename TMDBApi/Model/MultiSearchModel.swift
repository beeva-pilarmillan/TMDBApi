//
//  MultiSearchModel.swift
//  TheMovieDBClient
//
//  Created by Pilar Millán on 3/1/17.
//  Copyright © 2017 BEEVA. All rights reserved.
//

import Foundation

public typealias MultiSearchItems = [MediaType: [MediaItem]]

public class MultiSearchModel {

    public var mediaItems: MultiSearchItems = [MediaType.Movie: [], MediaType.TV: []]
    
    init?(json: JSON) {
 
        guard let results = json["results"].array else {
            return nil
        }
        
        for json in results {
            
            if let item = MediaItem.create(fromJSON: json), let mediaType = item.mediaType {
                mediaItems[mediaType]?.append(item)
            }
        }
    }
}
