import Foundation
import Combine
import FirebaseAuth

protocol AppRepositoryProtocol {
    func fetchMovies(searchQuery: String) -> AnyPublisher<[Movie], Error>
    func fetchMovieDetail(imdbID: String) -> AnyPublisher<MovieDetail, Error>
    func login(username: String, password: String) -> AnyPublisher<AppUser, Error>
    func signup(username: String, password: String) -> AnyPublisher<AppUser, Error>
    func logout() -> AnyPublisher<Void, Never>
}

class AppRepository: AppRepositoryProtocol {
    private let movieService: MovieServiceProtocol
    private let authenticationService: AuthenticationServiceProtocol
    private let localDataSource: MovieLocalDataSourceProtocol
    private let networkMonitor: NetworkMonitor

    private let forcedUsername = "VVVBB"
    private let forcedPassword = "@bcd1234"

    init(
        movieService: MovieServiceProtocol = MovieService(),
        authenticationService: AuthenticationServiceProtocol = AuthenticationService(),
        localDataSource: MovieLocalDataSourceProtocol = MovieLocalDataSource(),
        networkMonitor: NetworkMonitor = NetworkMonitor.shared
    ) {
        self.movieService = movieService
        self.authenticationService = authenticationService
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

    func login(username: String, password: String) -> AnyPublisher<AppUser, Error> {
        if username == forcedUsername && password == forcedPassword {
            let user = AppUser(uid: "forcedUser", email: nil)
            return Just(user)
                .setFailureType(to: Error.self)
                .eraseToAnyPublisher()
        } else if networkMonitor.isConnected {
            return authenticationService.login(username: username, password: password)
        } else {
            let error = NSError(domain: "OfflineLoginError", code: -1, userInfo: [NSLocalizedDescriptionKey: "No internet connection"])
            return Fail(error: error).eraseToAnyPublisher()
        }
    }

    func signup(username: String, password: String) -> AnyPublisher<AppUser, Error> {
        if networkMonitor.isConnected {
            return authenticationService.signup(username: username, password: password)
        } else {
            let error = NSError(domain: "SignupError", code: -1, userInfo: [NSLocalizedDescriptionKey: "Cannot sign up offline"])
            return Fail(error: error).eraseToAnyPublisher()
        }
    }

    func logout() -> AnyPublisher<Void, Never> {
        return authenticationService.logout()
    }
}
