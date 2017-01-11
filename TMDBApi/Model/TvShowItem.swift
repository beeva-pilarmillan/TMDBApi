//
//  TvShowItem.swift
//  TheMovieDBClient
//
//  Created by Pilar Millán on 5/1/17.
//  Copyright © 2017 BEEVA. All rights reserved.
//

import Foundation

public typealias Creators = [String]
public typealias Languages = [String]

public class TvShowItem: MediaItem {
    public let name: String?
    public let originalName: String?
    public let firstAirDate: String?
    public let lastAirDate: String?
    public let originCountry: [String]?
    public let createdBy: Creators?
    public let episodeRuntimes: [Int]?
    public let genres: Genres?
    public let homepage: String?
    public let inProduction: Bool
    public let languages: Languages?
    public let networks: ProductionCompanies?
    public let productionCompanies: ProductionCompanies?
    public let numberOfEpisodes: Int
    public let numberOfSeasons: Int
    public let status: String?
    public let type: String?
   public  let seasons: [TVShowSeason]?
    
    override init?(json: JSON) {
        name = json["name"].string
        originalName = json["original_name"].string
        firstAirDate = json["first_air_date"].string
        originCountry = json["origin_country"].arrayObject as? [String]
        createdBy = TvShowItem.getCreatedBy(fromJSON: json)
        episodeRuntimes = json["episode_runtime"].arrayObject as? [Int]
        genres = TvShowItem.getGenres(json: json)
        homepage = json["homepage"].string
        inProduction = json["in_production"].boolValue
        languages = json["languages"].arrayObject as? Languages
        lastAirDate = json["last_air_date"].string
        networks = TvShowItem.getProductionCompanies(companies: json["networks"].array)
        productionCompanies = TvShowItem.getProductionCompanies(companies: json["production_companies"].array)
        numberOfEpisodes = json["number_of_episodes"].intValue
        numberOfSeasons = json["number_of_seasons"].intValue
        status = json["status"].string
        type = json["type"].string
        seasons = TvShowItem.getSeasons(fromJSON: json)
        super.init(json: json)
    }
}

private extension TvShowItem {
    
    static func getCreatedBy(fromJSON json: JSON) -> Creators? {
        
        guard let creatorsJSON = json["created_by"].array else {
            return nil
        }
        
        var creators = Creators()
        
        for creator in creatorsJSON {
            if let name = creator["name"].string {
                creators.append(name)
            }
        }
        
        return !creators.isEmpty ? creators : nil
    }
    
    static func getSeasons(fromJSON json: JSON) -> [TVShowSeason]? {
    
        guard let seasonsJSON = json["seasons"].array else {
            return nil
        }
        
        var seasons: [TVShowSeason] = []
        
        for json in seasonsJSON {
            if let season = TVShowSeason(json: json) {
                seasons.append(season)
            }
        }
        
        return !seasons.isEmpty ? seasons : nil
    }
}
