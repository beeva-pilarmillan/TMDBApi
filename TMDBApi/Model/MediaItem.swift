//
//  MediaItem.swift
//  TheMovieDBClient
//
//  Created by Pilar Millán on 3/1/17.
//  Copyright © 2017 BEEVA. All rights reserved.
//

import Foundation

public typealias Genres = [Int: String]
public typealias ProductionCompanies = [Int: String]
public typealias ProductionCountries = [String: String]
public typealias SpokenLanguages = [String: String]

public enum MediaType: String {
    case Movie = "movie"
    case TV = "tv"
}

public class MediaItem {
    public var mediaType: MediaType?
    public let id: Int
    public let posterImagePath: String?
    public let backdropImagePath: String?
    public let overview: String?
    public let genreIds: [Int]?
    public let originalLanguage: String?
    public let popularity: Double?
    public let voteCount: Int?
    public let voteAverage: Double?

    init?(json: JSON) {
        guard let id = json["id"].int else {
            return nil
        }
        self.id = id
        mediaType = MediaType(rawValue: json["media_type"].stringValue)
        posterImagePath = json["poster_path"].string
        backdropImagePath = json["backdrop_path"].string
        overview = json["overview"].string
        genreIds = json["genre_ids"].arrayObject as? [Int]
        originalLanguage = json["original_language"].string
        popularity = json["popularity"].double
        voteCount = json["vote_count"].int
        voteAverage = json["vote_average"].double
    }
}

extension MediaItem {
    
    static func create(fromJSON json: JSON) -> MediaItem? {
        
        guard let mediaTypeString = json["media_type"].string,
            let mediaType = MediaType(rawValue: mediaTypeString) else {
                return nil
        }
        
        switch mediaType {
        case .Movie:
            return MovieItem(json: json)
        case .TV:
            return TvShowItem(json: json)
        }
    }
}

internal extension MediaItem {
    
    static func getProductionCompanies(companies: [JSON]?) -> ProductionCompanies? {
        
        guard let companies = companies else {
            return nil
        }
        
        var productionCompanies: ProductionCompanies = [:]
        
        for json in companies {
            if let companyId = json["id"].int, let name = json["name"].string {
                productionCompanies[companyId] = name
            }
        }
        
        return (productionCompanies.isEmpty) ? nil : productionCompanies
    }
    
    static func getProductionCountries(json: JSON) -> ProductionCountries? {
        
        guard let countries = json["production_countries"].array else {
            return nil
        }
        
        var productionCountries: ProductionCountries = [:]
        
        for json in countries {
            if let iso = json["iso_3166_1"].string, let name = json["name"].string {
                productionCountries[iso] = name
            }
        }
        
        return (productionCountries.isEmpty) ? nil : productionCountries
    }
    
    static func getGenres(json: JSON) -> Genres? {
     
        guard let genresArray = json["genres"].array else {
            return nil
        }
        
        var genres: Genres = [:]
        
        for json in genresArray {
            if let genreId = json["id"].int, let name = json["name"].string {
                genres[genreId] = name
            }
        }
        
        return (genres.isEmpty) ? nil : genres
    }
    
    static func getSpokenLanguages(json: JSON) -> SpokenLanguages? {
    
        guard let languages = json["spoken_languages"].array else {
            return nil
        }
        
        var spokenLanguages: SpokenLanguages = [:]
        
        for json in languages {
            if let iso = json["iso_639_1"].string, let name = json["name"].string {
                spokenLanguages[iso] = name
            }
        }
        
        return (spokenLanguages.isEmpty) ? nil : spokenLanguages

    }
}
