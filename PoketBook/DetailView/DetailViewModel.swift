//
//  DetailViewModel.swift
//  PoketBook
//
//  Created by 김석준 on 12/31/24.
//

import Foundation

final class DetailViewModel {
    private let pokemonDetail: PokemonDetail

    // MARK: - Computed Properties
    var imageURL: URL? {
        guard let urlString = pokemonDetail.sprites.frontDefault else { return nil }
        return URL(string: urlString)
    }

    var name: String {
        return "No.\(pokemonDetail.id) \(pokemonDetail.name.capitalized)"
    }
    
    var type: String {
        return "타입: \(pokemonDetail.types.map { $0.type.name.capitalized }.joined(separator: ", "))"
    }


    var height: String {
        return "키: \(pokemonDetail.height) m"
    }

    var weight: String {
        return "몸무게: \(pokemonDetail.weight) kg"
    }

    // MARK: - Initializer
    init(pokemonDetail: PokemonDetail) {
        self.pokemonDetail = pokemonDetail
    }
}
