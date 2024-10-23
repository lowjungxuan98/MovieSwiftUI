//
//  MovieDetailView.swift
//  movie app
//
//  Created by Low Jung Xuan on 22/10/2024.
//

import Foundation
import Combine

class MovieDetailViewModel: BaseViewModel {
    @Published var movieDetail: MovieDetail?
    
    func fetchMovieDetails(imdbID: String) {
        isLoading = true
        errorMessage = nil

        repository.fetchMovieDetail(imdbID: imdbID)
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
