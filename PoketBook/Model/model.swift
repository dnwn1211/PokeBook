//
//  model.swift
//  PoketBook
//
//  Created by 김석준 on 12/26/24.
//

import Foundation

struct PokemonListResponse: Decodable {
    let results: [PokemonListEntry]
}

struct PokemonListEntry: Decodable {
    let name: String
    let url: String
}

struct PokemonDetail: Decodable {
    let id: Int
    let name: String
    let sprites: PokemonSprites
    let types: [PokemonTypeSlot]
}

struct PokemonSprites: Decodable {
    let frontDefault: String?

    enum CodingKeys: String, CodingKey {
        case frontDefault = "front_default"
    }
}

struct PokemonTypeSlot: Decodable {
    let slot: Int
    let type: PokemonType
}

struct PokemonType: Decodable {
    let name: String
}
