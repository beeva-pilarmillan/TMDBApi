//
//  TVShowsDataSource.swift
//  TheMovieDBClient
//
//  Created by Pilar Millán on 7/1/17.
//  Copyright © 2017 BEEVA. All rights reserved.
//

import Foundation

public protocol TVShowsDataSource {
    weak var tvShowsDataSourceOutput: TVShowsDataSourceOutput? { get set }
    func getTVShowDetail(tvShowId: Int)
    func discoverTVShows(page: Int?)
    func getPopularTVShows()
    func rateTVShow(tvShowId: Int, score: Double)
    func searchTVShow(withText text: String, page: Int?)
    func getTVShowSeasonDetail(forTVShowId tvShowId: Int, seasonNumber: Int)
    func getImage(withPath path: String, completionHandler: @escaping (_ data: Data?, _ error: Error?) -> Void)
    init(tvShowsDataSourceOutput: TVShowsDataSourceOutput?)
}

public protocol TVShowsDataSourceOutput: class {
    func onTVShowDetailSuccess(tvShow: TvShowItem?)
    func onTVShowDetailError(error: Error?)
    
    func onDiscoverTVShowSuccess(tvShows: TVShowDiscoverModel?, currentPage: Int, totalPages: Int, totalTVShows: Int)
    func onDiscoverTVShowError(error: Error?)
    
    func onPopularTVShowSuccess(popularTVShows: TVShowDiscoverModel?)
    func onPopularTVShowsError(error: Error?)
    
    func onSearchTVShowSuccess(tvShows: [TvShowItem]?, currentPage: Int, totalPages: Int, totalTVShows: Int)
    func onSearchTVShowError(error: Error?)
    
    func onRateTVShowSuccess()
    func onRateTVShowError(error: Error?)
    
    func onTVShowSeasonDetailSuccess(seasonNumber: Int, season: TVShowSeason?)
    func onTVShowSeasonDetailError(error: Error?)
}

public class TVShowsDataSourceImpl: TMDBDataSource {
    
    weak public var tvShowsDataSourceOutput: TVShowsDataSourceOutput?
    var dataManager: NetworkDataManager = NetworkDataManagerImpl.sharedInstance
   
    required public init(tvShowsDataSourceOutput: TVShowsDataSourceOutput?) {
        self.tvShowsDataSourceOutput = tvShowsDataSourceOutput
    }
}

extension TVShowsDataSourceImpl: TVShowsDataSource {
    
    public func getTVShowDetail(tvShowId: Int) {
        
        let operation = TVShowDetailNetworkOperation(tvShowId: tvShowId)
        
        dataManager.execute(operation: operation) { [weak self] in
            if let error = operation.error {
                self?.tvShowsDataSourceOutput?.onTVShowDetailError(error: error)
            } else {
                self?.tvShowsDataSourceOutput?.onTVShowDetailSuccess(tvShow: operation.tvShow)
            }
        }
    }
    
    public func discoverTVShows(page: Int?) {
        
        let operation = TVShowDiscoverNetworkOperation(pagetToSearch: page)
        
        dataManager.execute(operation: operation) { [weak self] in
            if let error = operation.error {
                self?.tvShowsDataSourceOutput?.onDiscoverTVShowError(error: error)
            } else {
                self?.tvShowsDataSourceOutput?.onDiscoverTVShowSuccess(tvShows: operation.tvShows,
                                                                       currentPage: operation.page,
                                                                       totalPages: operation.totalPages,
                                                                       totalTVShows: operation.totalResults)
            }
        }
    }
    
    public func getPopularTVShows() {
        
        let operation = TVShowPopularNetworkOperation()
        
        dataManager.execute(operation: operation) { [weak self] in
            if let error = operation.error {
                self?.tvShowsDataSourceOutput?.onPopularTVShowsError(error: error)
            } else {
                self?.tvShowsDataSourceOutput?.onPopularTVShowSuccess(popularTVShows: operation.tvShows)
            }
        }
    }
    
    public func rateTVShow(tvShowId: Int, score: Double) {
        
        getGuestAuthentication { [weak self] (sessionData, error) in
            if let session = sessionData {
                
                let operation = TVShowRateNetworkOperation(tvShowId: tvShowId, score: score, sessionId: session.sessionId)
                
                self?.dataManager.execute(operation: operation) {
                    if let error = operation.error {
                        self?.tvShowsDataSourceOutput?.onRateTVShowError(error: error)
                    } else {
                        self?.tvShowsDataSourceOutput?.onRateTVShowSuccess()
                    }
                }
                
            } else {
                self?.tvShowsDataSourceOutput?.onRateTVShowError(error: error)
            }
        }
    }
    
    public func searchTVShow(withText text: String, page: Int?) {
        
        let operation = TVShowSearchNetworkOperation(textToSearch: text, pageToSearchIn: page)
        
        dataManager.execute(operation: operation) { [weak self] in
            if let error = operation.error {
                self?.tvShowsDataSourceOutput?.onSearchTVShowError(error: error)
            } else {
                self?.tvShowsDataSourceOutput?.onSearchTVShowSuccess(tvShows: operation.searchResults,
                                                                     currentPage: operation.page,
                                                                     totalPages: operation.totalPages,
                                                                     totalTVShows: operation.totalResults)
            }
        }
    }
    
    public func getTVShowSeasonDetail(forTVShowId tvShowId: Int, seasonNumber: Int) {
        
        let operation = TVShowSeasonDetailNetworkOperation(tvShowId: tvShowId, seasonNumber: seasonNumber)
        
        dataManager.execute(operation: operation) { [weak self] in
            if let error = operation.error {
                self?.tvShowsDataSourceOutput?.onTVShowSeasonDetailError(error: error)
            } else {
                self?.tvShowsDataSourceOutput?.onTVShowSeasonDetailSuccess(seasonNumber: seasonNumber, season: operation.season)
            }
        }
    }
}
