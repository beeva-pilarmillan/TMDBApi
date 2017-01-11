//
//  MovieItem.swift
//  TheMovieDBClient
//
//  Created by Pilar Millán on 5/1/17.
//  Copyright © 2017 BEEVA. All rights reserved.
//

import Foundation

public class MovieItem: MediaItem {
    public let title: String?
    public let originalTitle: String?
    public let releaseDate: String?
    public let adult: Bool
    public let video: Bool
    public let budget: Int?
    public let homePage: String?
    public let imdbId: String?
    public let genres: Genres?
    public let productionCompanies: ProductionCompanies?
    public let productionCountries: ProductionCountries?
    public let revenue: Int?
    public let runtime: Int?
    public let spokenLanguages: SpokenLanguages?
    public let status: String?
    public let tagline: String?
    
    override init?(json: JSON) {
        title = json["title"].string
        originalTitle = json["original_title"].string
        releaseDate = json["release_date"].string
        adult = json["adult"].boolValue
        video = json["video"].boolValue
        budget = json["budget"].int
        homePage = json["homepage"].string
        imdbId = json["imdb_id"].string
        genres = MovieItem.getGenres(json: json)
        productionCompanies = MovieItem.getProductionCompanies(companies: json["production_companies"].array)
        productionCountries = MovieItem.getProductionCountries(json: json)
        spokenLanguages = MovieItem.getSpokenLanguages(json: json)
        revenue = json["revenue"].int
        runtime = json["runtime"].int
        status = json["status"].string
        tagline = json["tagline"].string
        super.init(json: json)
        
        if mediaType == nil {
            mediaType = .Movie
        }
    }
}
