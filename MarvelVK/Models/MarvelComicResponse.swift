//
//  MarvelComicResponse.swift
//  MarvelVK
//
//  Created by Tarlan Askaruly on 03.04.2022.
//

import Foundation

struct MarvelComicResponse: Codable {
    var code: Int
    var status: String
    var data: MarvelComicData?
}

struct MarvelComicData: Codable {
    var results: [MarvelComicResult]?
}

struct MarvelComicResult: Codable {
    var thumbnail: MarvelCharacterThumbnail
}
