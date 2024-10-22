//
//  MovieList.swift
//  movie app
//
//  Created by Low Jung Xuan on 22/10/2024.
//

import Foundation

struct MovieList: Decodable {
    let movies: [Movie]

    enum CodingKeys: String, CodingKey {
        case movies = "Search"
    }
}
