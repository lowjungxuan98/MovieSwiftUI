//
//  MovieService.swift
//  movie app
//
//  Created by Low Jung Xuan on 23/10/2024.
//

import Foundation
import Combine

protocol MovieServiceProtocol {
    func fetchMovies(searchQuery: String) -> AnyPublisher<[Movie], Error>
    func fetchMovieDetail(imdbID: String) -> AnyPublisher<MovieDetail, Error>
}

class MovieService: MovieServiceProtocol {
    private let apiKey = "6fc87060"
    private let baseURL = "http://www.omdbapi.com/"

    func fetchMovies(searchQuery: String) -> AnyPublisher<[Movie], Error> {
        guard let url = URL(string: "\(baseURL)?apikey=\(apiKey)&s=\(searchQuery)&type=movie") else {
            return Fail(error: URLError(.badURL)).eraseToAnyPublisher()
        }

        return URLSession.shared.dataTaskPublisher(for: url)
            .map(\.data)
            .decode(type: MovieList.self, decoder: JSONDecoder())
            .map { $0.movies }
            .eraseToAnyPublisher()
    }

    func fetchMovieDetail(imdbID: String) -> AnyPublisher<MovieDetail, Error> {
        guard let url = URL(string: "\(baseURL)?apikey=\(apiKey)&i=\(imdbID)") else {
            return Fail(error: URLError(.badURL)).eraseToAnyPublisher()
        }

        return URLSession.shared.dataTaskPublisher(for: url)
            .map(\.data)
            .decode(type: MovieDetail.self, decoder: JSONDecoder())
            .eraseToAnyPublisher()
    }
}
