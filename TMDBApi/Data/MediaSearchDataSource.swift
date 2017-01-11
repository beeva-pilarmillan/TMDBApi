//
//  MediaSearchDataSource.swift
//  TheMovieDBClient
//
//  Created by Pilar Millán on 7/1/17.
//  Copyright © 2017 BEEVA. All rights reserved.
//

import Foundation

public protocol MediaSearchDataSource {
    weak var mediaSearchDataSourceOutput: MediaSearchDataSourceOutput? { get set }
    func searchMedia(forText text: String, page: Int?)
    func getImage(withPath path: String, completionHandler: @escaping (_ data: Data?, _ error: Error?) -> Void)
    init(mediaSearchDataSourceOutput: MediaSearchDataSourceOutput?)
}

public protocol MediaSearchDataSourceOutput: class {
    func onSearchMediaSuccess(movies: [MovieItem]?, tvShows: [TvShowItem]?, currentPage: Int, totalPages: Int, totalResults: Int)
    func onSearchMediaError(error: Error?)
}

public class MediaSearchDataSourceImpl: TMDBDataSource {
    
    weak public var mediaSearchDataSourceOutput: MediaSearchDataSourceOutput?
    var dataManager: NetworkDataManager = NetworkDataManagerImpl.sharedInstance
    
    required public init(mediaSearchDataSourceOutput: MediaSearchDataSourceOutput?) {
        self.mediaSearchDataSourceOutput = mediaSearchDataSourceOutput
    }
}

extension MediaSearchDataSourceImpl: MediaSearchDataSource {
    
    public func searchMedia(forText text: String, page: Int?) {
        
        let operation = MultisearchNetworkOperation.init(textToSearch: text, pageToSearchIn: page)
        
        dataManager.execute(operation: operation) { [weak self] in
            if let error = operation.error {
                self?.mediaSearchDataSourceOutput?.onSearchMediaError(error: error)
            } else {
                let results = operation.searchResults
                let movies = results?.mediaItems[MediaType.Movie] as? [MovieItem]
                let tvShows = results?.mediaItems[MediaType.TV] as? [TvShowItem]
                self?.mediaSearchDataSourceOutput?.onSearchMediaSuccess(movies: movies,
                                                                        tvShows: tvShows,
                                                                        currentPage: operation.page,
                                                                        totalPages: operation.totalPages,
                                                                        totalResults: operation.totalResults)
            }
        }
    }
}
