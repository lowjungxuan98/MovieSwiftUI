//
//  Rating.swift
//  movie app
//
//  Created by Low Jung Xuan on 22/10/2024.
//

import Foundation

struct Rating: Codable {
    let source, value: String

    enum CodingKeys: String, CodingKey {
        case source = "Source"
        case value = "Value"
    }
}
