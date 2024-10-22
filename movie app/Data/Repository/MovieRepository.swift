import Foundation
import RealmSwift
import Combine

protocol MovieRepositoryProtocol {
    func fetchMovies(searchQuery: String) -> AnyPublisher<[Movie], Error>
    func fetchMovieDetail(imdbID: String) -> AnyPublisher<MovieDetail, Error>
}
//
class MovieRepository: MovieRepositoryProtocol {
    private let movieService: MovieServiceProtocol
    private let localDataSource: MovieLocalDataSourceProtocol
    private let networkMonitor: NetworkMonitor

    init(movieService: MovieServiceProtocol = MovieService(),
         localDataSource: MovieLocalDataSourceProtocol = MovieLocalDataSource(),
         networkMonitor: NetworkMonitor = NetworkMonitor.shared) {
        self.movieService = movieService
        self.localDataSource = localDataSource
        self.networkMonitor = networkMonitor
    }

    func fetchMovies(searchQuery: String) -> AnyPublisher<[Movie], Error> {
        if networkMonitor.isConnected {
            return movieService.fetchMovies(searchQuery: searchQuery)
                .handleEvents(receiveOutput: { [weak self] movies in
                    self?.localDataSource.saveMovies(movies)
                })
                .eraseToAnyPublisher()
        } else {
            return localDataSource.fetchMovies(searchQuery: searchQuery)
        }
    }

    func fetchMovieDetail(imdbID: String) -> AnyPublisher<MovieDetail, Error> {
        if networkMonitor.isConnected {
            return movieService.fetchMovieDetail(imdbID: imdbID)
                .eraseToAnyPublisher()
        } else {
            return Fail(error: URLError(.notConnectedToInternet)).eraseToAnyPublisher()
        }
    }
}
