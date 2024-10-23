//
//  BaseViewModel.swift
//  movie app
//
//  Created by Low Jung Xuan on 23/10/2024.
//

import Foundation
import Combine

class BaseViewModel: ObservableObject {
    @Published var isLoading: Bool = false
    @Published var errorMessage: String?

    var cancellables = Set<AnyCancellable>()
    let repository: AppRepositoryProtocol

    init(repository: AppRepositoryProtocol = AppRepository()) {
        self.repository = repository
    }
}
