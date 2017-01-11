//
//  TVShowSeason.swift
//  TheMovieDBClient
//
//  Created by Pilar Millán on 7/1/17.
//  Copyright © 2017 BEEVA. All rights reserved.
//

import Foundation

public typealias Episodes = [TVShowEpisode]

public struct TVShowSeason {
    public let id: Int
    public let airDate: String?
    public let episodeCount: Int
    public let posterImagePath: String?
    public let seasonNumber: Int
    public let name: String?
    public let overview: String?
    public let episodes: Episodes?
    
    init?(json: JSON) {
        guard let id = json["id"].int, let seasonNumber = json["season_number"].int else {
            return nil
        }
        
        self.id = id
        self.seasonNumber = seasonNumber
        airDate = json["air_date"].string
        episodeCount = json["episode_count"].intValue
        posterImagePath = json["poster_path"].string
        name = json["name"].string
        overview = json["overview"].string
        episodes = TVShowSeason.getEpisodes(fromJSON: json)
    }
}

private extension TVShowSeason {
    
    static func getEpisodes(fromJSON json: JSON) -> Episodes? {
        
        guard let episodesJSON = json["episodes"].array else {
            return nil
        }
        
        var episodes = Episodes()
        
        for json in episodesJSON {
            episodes.append(TVShowEpisode(json: json))
        }
        
        return !episodes.isEmpty ? episodes : nil
    }
}
