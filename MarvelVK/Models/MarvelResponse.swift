//
//  MarvelResponse.swift
//  MarvelVK
//
//  Created by Tarlan Askaruly on 31.03.2022.
//

import Foundation

struct MarvelResponse: Codable {
    var code: Int
    var status: String
    var data: MarvelData?
}

struct MarvelData: Codable {
    var results: [MarvelCharacter]?
}

struct MarvelCharacter: Codable {
    var id: Int
    var name: String
    var description: String
    var comics: ComicsData
    var thumbnail: MarvelCharacterThumbnail
    var urls: [[String: String]]
}

struct MarvelCharacterThumbnail: Codable {
    var path: String
    var `extension`: String
}

struct MarvelComic: Codable {
    var resourceURI: String
    var name: String
}

struct ComicsData: Codable {
    var items: [MarvelComic]
}
