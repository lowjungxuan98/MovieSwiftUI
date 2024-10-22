//
//  MovieDetailView.swift
//  movie app
//
//  Created by Low Jung Xuan on 22/10/2024.
//

import Foundation
import Combine

class MovieDetailViewModel: ObservableObject {
    @Published var movieDetail: MovieDetail?
    @Published var isLoading: Bool = false
    @Published var errorMessage: String?

    private var cancellables = Set<AnyCancellable>()
    private let movieService: MovieServiceProtocol

    init(movieService: MovieServiceProtocol = MovieService()) {
        self.movieService = movieService
    }
    
    func fetchMovieDetails(imdbID: String) {
        isLoading = true
        errorMessage = nil

        movieService.fetchMovieDetail(imdbID: imdbID)
            .receive(on: DispatchQueue.main)
            .sink { [weak self] completion in
                self?.isLoading = false
                switch completion {
                case .failure(let error):
                    self?.errorMessage = error.localizedDescription
                case .finished:
                    break
                }
            } receiveValue: { [weak self] movieDetail in
                self?.movieDetail = movieDetail
            }
            .store(in: &cancellables)
    }
}

