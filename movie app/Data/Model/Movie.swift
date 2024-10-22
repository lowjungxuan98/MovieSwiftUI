//
//  Movie.swift
//  movie app
//
//  Created by Low Jung Xuan on 22/10/2024.
//

import Foundation

struct Movie: Decodable {
    let title: String
    let year: String
    let imdbID: String
    let type: String
    let poster: String
    
    enum CodingKeys: String, CodingKey {
        case title = "Title"
        case year = "Year"
        case imdbID = "imdbID"
        case type = "Type"
        case poster = "Poster"
    }
}

extension Movie {
    init(entity: MovieEntity) {
        self.title = entity.title
        self.year = entity.year
        self.imdbID = entity.imdbID
        self.type = entity.type
        self.poster = entity.poster
    }
}
