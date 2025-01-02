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
            // 포켓몬 이름을 한국어로 변환
            let koreanName = PokemonTranslator.getKoreanName(for: pokemonDetail.name)
            return "No.\(pokemonDetail.id) \(koreanName)"
        }
    
    var type: String {
        // 각 타입을 한국어로 변환
        let typeNames = pokemonDetail.types.map { type -> String in
            guard let pokemonType = PokemonTypeName(rawValue: type.type.name)
            else {
                return type.type.name.capitalized
            }
                return pokemonType.displayName
            }
            return "타입: \(typeNames.joined(separator: ", "))"
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
