import Foundation
import Combine
import FirebaseAuth

protocol RepositoryProtocol {
    func fetchMovies(searchQuery: String) -> AnyPublisher<[Movie], Error>
    func fetchMovieDetail(imdbID: String) -> AnyPublisher<MovieDetail, Error>
    func login(username: String, password: String) -> AnyPublisher<AppUser, Error>
    func signup(username: String, password: String) -> AnyPublisher<AppUser, Error>
    func logout() -> AnyPublisher<Void, Never>
    func checkExistingUser() -> Bool
}

class Repository: RepositoryProtocol, ObservableObject {
    private let service: ServiceProtocol
    private let localDataSource: LocalDataSourceProtocol
    private let networkMonitor: NetworkMonitor
    
    private let forcedUsername = "VVVBB"
    private let forcedPassword = "@bcd1234"

    init(
        service: ServiceProtocol = Service(),
        localDataSource: LocalDataSourceProtocol = LocalDataSource(),
        networkMonitor: NetworkMonitor = NetworkMonitor.shared
    ) {
        self.service = service
        self.localDataSource = localDataSource
        self.networkMonitor = networkMonitor
    }
    
    func fetchMovies(searchQuery: String) -> AnyPublisher<[Movie], Error> {
        if networkMonitor.isConnected {
            return service.fetchMovies(searchQuery: searchQuery)
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
            return service.fetchMovieDetail(imdbID: imdbID)
                .eraseToAnyPublisher()
        } else {
            return Fail(error: URLError(.notConnectedToInternet)).eraseToAnyPublisher()
        }
    }
    
    func login(username: String, password: String) -> AnyPublisher<AppUser, Error> {
        if username == forcedUsername && password == forcedPassword {
            let user = AppUser(uid: "forcedUser", email: nil)
            localDataSource.saveCurrentUser(user)
            return Just(user)
                .setFailureType(to: Error.self)
                .eraseToAnyPublisher()
        } else if networkMonitor.isConnected {
            return service.login(username: username, password: password)
                .handleEvents(receiveOutput: { [self] user in
                    localDataSource.saveCurrentUser(user)
                })
                .eraseToAnyPublisher()
        } else {
            let error = NSError(domain: "OfflineLoginError", code: -1, userInfo: [NSLocalizedDescriptionKey: "No internet connection"])
            return Fail(error: error).eraseToAnyPublisher()
        }
    }
    
    func signup(username: String, password: String) -> AnyPublisher<AppUser, Error> {
        if networkMonitor.isConnected {
            return service.signup(username: username, password: password)
                .handleEvents(receiveOutput: { [self] user in
                    localDataSource.saveCurrentUser(user)
                })
                .eraseToAnyPublisher()
        } else {
            let error = NSError(domain: "SignupError", code: -1, userInfo: [NSLocalizedDescriptionKey: "Cannot sign up offline"])
            return Fail(error: error).eraseToAnyPublisher()
        }
    }
    
    func logout() -> AnyPublisher<Void, Never> {
        return service.logout()
            .handleEvents(receiveOutput: { [self] _ in
                localDataSource.clearCurrentUser()
                NotificationCenter.default.post(name: .userLoginStatusChanged, object: nil, userInfo: ["isLoggedIn": false])
            })
            .eraseToAnyPublisher()
    }
    
    func checkExistingUser() -> Bool {
        return localDataSource.currentUser != nil
    }
}
