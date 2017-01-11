//
//  TVShowEpisode.swift
//  TheMovieDBClient
//
//  Created by Pilar Millán on 7/1/17.
//  Copyright © 2017 BEEVA. All rights reserved.
//

import Foundation

public typealias CrewModel = [Crew]
public typealias GuestStars = [GuestStar]

public struct Crew {
    public let id: Int?
    public let creditId: String?
    public let name: String?
    public let department: String?
    public let job: String?
    public let profileImagePath: String?
    
    init(json: JSON) {
        id = json["id"].int
        name = json["name"].string
        creditId = json["credit_id"].string
        department = json["department"].string
        job = json["job"].string
        profileImagePath = json["profile_path"].string
    }
}

public struct GuestStar {
    public let id: Int?
    public let name: String?
    public let creditId: String?
    public let character: String?
    public let order: Int?
    public let profileImagePath: String?
    
    init(json: JSON) {
        id = json["id"].int
        name = json["name"].string
        creditId = json["credit_id"].string
        character = json["character"].string
        order = json["order"].int
        profileImagePath = json["profile_path"].string
    }
}

public struct TVShowEpisode {
    public let id: Int?
    public let name: String?
    public let overview: String?
    public let productionCode: Int?
    public let seasonNumber: Int?
    public let imagePath: String?
    public let voteAverage: Double?
    public let voteCount: Int?
    public let airDate: String?
    public let episodeNumber: Int?
    public let guestStars: GuestStars?
    public let crew: CrewModel?
    
    init(json: JSON) {
        id = json["id"].int
        name = json["name"].string
        overview = json["overview"].string
        productionCode = json["production_code"].int
        seasonNumber = json["season_number"].int
        imagePath = json["still_path"].string
        voteAverage = json["vote_average"].double
        voteCount = json["vote_count"].int
        airDate = json["air_date"].string
        episodeNumber = json["episode_number"].int
        guestStars = TVShowEpisode.getGuestStars(fromJSON: json)
        crew = TVShowEpisode.getCrew(fromJSON: json)
    }
}

private extension TVShowEpisode {
    
    static func getGuestStars(fromJSON json: JSON) -> [GuestStar]? {
        
        guard let guestStartsJSON = json["guest_stars"].array else {
            return nil
        }
        
        var guestStars = [GuestStar]()

        for json in guestStartsJSON {
            guestStars.append(GuestStar(json: json))
        }
        
        return !guestStars.isEmpty ? guestStars : nil
    }
    
    static func getCrew(fromJSON json: JSON) -> [Crew]? {
        
        guard let crewJSON = json["crew"].array else {
            return nil
        }
        
        var crew = [Crew]()
        
        for json in crewJSON {
            crew.append(Crew(json: json))
        }
        
        return !crew.isEmpty ? crew : nil
    }
}
