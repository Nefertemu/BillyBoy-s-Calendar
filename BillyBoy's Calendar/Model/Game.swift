//
//  Game.swift
//  BillyBoy's Calendar
//
//  Created by Bogdan Anishchenkov on 19.09.2022.
//

import Foundation

struct Result: Decodable {
    let results: [Game]
}

struct Game: Decodable {
    let name: String
    let released: String
    let background_image: String
    let short_screenshots: [Screenshot]
    let genres: [Genre]
}

struct Screenshot: Decodable {
    let image: String
}

struct Genre: Decodable {
    let name: String
}
