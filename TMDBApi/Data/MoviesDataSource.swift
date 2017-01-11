//
//  MoviesDataSource.swift
//  TheMovieDBClient
//
//  Created by Pilar Millán on 7/1/17.
//  Copyright © 2017 BEEVA. All rights reserved.
//

import Foundation

public protocol MoviesDataSource {
    weak var moviesDatasourceOutput: MoviesDataSourceOutput? { get set }
    func getMovieDetail(movieId: Int)
    func discoverMovies(page: Int?)
    func getPopularMovies()
    func rateMovie(movieId: Int, score: Double)
    func searchMovie(withText text: String, page: Int?)
    func getImage(withPath path: String, completionHandler: @escaping (_ data: Data?, _ error: Error?) -> Void)
    init(moviesDatasourceOutput: MoviesDataSourceOutput?)
}

public protocol MoviesDataSourceOutput: class {
    func onMovieDetailSuccess(movie: MovieItem?)
    func onMovieDetailError(error: Error?)
    
    func onDiscoverMoviesSuccess(movies: MovieDiscoverModel?, currentPage: Int, totalPages: Int, totalMovies: Int)
    func onDiscoverMovieError(error: Error?)
    
    func onPopularMoviesSuccess(popularMovies: MoviePopularModel?)
    func onPopularMoviesError(error: Error?)
    
    func onSearchMovieSuccess(movies: [MovieItem]?, currentPage: Int, totalPages: Int, totalMovies: Int)
    func onSearchMovieError(error: Error?)
    
    func onRateMovieSuccess()
    func onRateMovieError(error: Error?)
}

public class MoviesDataSourceImpl: TMDBDataSource {
    
    weak public var moviesDatasourceOutput: MoviesDataSourceOutput?
    var dataManager: NetworkDataManager = NetworkDataManagerImpl.sharedInstance

    required public init(moviesDatasourceOutput: MoviesDataSourceOutput?) {
        self.moviesDatasourceOutput = moviesDatasourceOutput
    }
}

extension MoviesDataSourceImpl: MoviesDataSource {
    
    public func getMovieDetail(movieId: Int) {
        
        let operation = MovieDetailNetworkOperation(movieId: movieId)
        
        dataManager.execute(operation: operation) { [weak self] in
            if let error = operation.error {
                self?.moviesDatasourceOutput?.onMovieDetailError(error: error)
            } else {
                self?.moviesDatasourceOutput?.onMovieDetailSuccess(movie: operation.movie)
            }
        }
    }
    
    public func discoverMovies(page: Int?) {
        
        let operation = MovieDiscoverNetworkOperation(pagetToSearch: page)
        
        dataManager.execute(operation: operation) { [weak self] in
            if let error = operation.error {
                self?.moviesDatasourceOutput?.onDiscoverMovieError(error: error)
            } else {
                self?.moviesDatasourceOutput?.onDiscoverMoviesSuccess(movies: operation.movies,
                                                                      currentPage: operation.page,
                                                                      totalPages: operation.totalPages,
                                                                      totalMovies: operation.totalResults)
            }
        }
    }
    
    public func getPopularMovies() {
        
        let operation = MoviePopularNetworkOperation()
        
        dataManager.execute(operation: operation) { [weak self] in
            if let error = operation.error {
                self?.moviesDatasourceOutput?.onPopularMoviesError(error: error)
            } else {
                self?.moviesDatasourceOutput?.onPopularMoviesSuccess(popularMovies: operation.movies)
            }
        }
    }
    
    public func rateMovie(movieId: Int, score: Double) {
        
        getGuestAuthentication { [weak self] (sessionData, error) in
            
            if let session = sessionData {
                
                let operation = MovieRateNetworkOperation(movieId: movieId, score: score, sessionId: session.sessionId)
                
                self?.dataManager.execute(operation: operation) {
                    if let error = operation.error {
                        self?.moviesDatasourceOutput?.onRateMovieError(error: error)
                    } else if operation.isRateSuccessful {
                        self?.moviesDatasourceOutput?.onRateMovieSuccess()
                    }
                }
                
            } else {
                self?.moviesDatasourceOutput?.onRateMovieError(error: error)
            }
        }
        
        let authenticationGuestSessionOperation = AuthenticationGuestSessionNetworkOperation()
        
        dataManager.execute(operation: authenticationGuestSessionOperation) { [weak self] in
            if let session = authenticationGuestSessionOperation.guestSessionData {
                
                let operation = MovieRateNetworkOperation(movieId: movieId, score: score, sessionId: session.sessionId)
                
                self?.dataManager.execute(operation: operation) {
                    if let error = operation.error {
                        self?.moviesDatasourceOutput?.onRateMovieError(error: error)
                    } else if operation.isRateSuccessful {
                        self?.moviesDatasourceOutput?.onRateMovieSuccess()
                    }
                }
            }
        }
    }
    
    public func searchMovie(withText text: String, page: Int?) {
        
        let operation = MovieSearchNetworkOperation(textToSearch: text, pageToSearchIn: page)
        
        dataManager.execute(operation: operation) { [weak self] in
            if let error = operation.error {
                self?.moviesDatasourceOutput?.onSearchMovieError(error: error)
            } else {
                self?.moviesDatasourceOutput?.onSearchMovieSuccess(movies: operation.searchResults,
                                                                   currentPage: operation.page,
                                                                   totalPages: operation.totalPages,
                                                                   totalMovies: operation.totalResults)
            }
        }
    }
}
