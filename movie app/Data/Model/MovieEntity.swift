//
//  s.swift
//  movie app
//
//  Created by Low Jung Xuan on 23/10/2024.
//

import RealmSwift
import Foundation

class MovieEntity: Object {
    @objc dynamic var title: String = ""
    @objc dynamic var year: String = ""
    @objc dynamic var imdbID: String = ""
    @objc dynamic var type: String = ""
    @objc dynamic var poster: String = ""
    
    override static func primaryKey() -> String? {
        return "imdbID"
    }
}

extension MovieEntity {
    convenience init(movie: Movie) {
        self.init()
        self.title = movie.title
        self.year = movie.year
        self.imdbID = movie.imdbID
        self.type = movie.type
        self.poster = movie.poster
    }
}
