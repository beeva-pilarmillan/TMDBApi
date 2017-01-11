//
//  TMDBApiConfiguration.swift
//  TheMovieDBClient
//
//  Created by Pilar Millán on 27/12/16.
//  Copyright © 2016 BEEVA. All rights reserved.
//

import Foundation

protocol TMDBApiConfiguration {
    var apiKey: String { get }
    var serverHost: String { get }
    var imageServerHost: String { get }
}

struct TMDBApiConfigurationImpl: TMDBApiConfiguration {
    
    var apiKey: String {
        return "49be48a297094ef7ad79c8fbbbff585c"
    }
    
    var serverHost: String {
        return "https://api.themoviedb.org/3"
    }
    
    var imageServerHost: String {
        return "https://image.tmdb.org/t/p/original"
    }
}
