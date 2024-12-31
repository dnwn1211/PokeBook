import Foundation

// MARK: - 포켓몬 리스트 API 응답 구조
struct PokemonListResponse: Decodable {
    let count: Int            // 전체 포켓몬 개수
    let next: String?         // 다음 페이지 URL
    let previous: String?     // 이전 페이지 URL
    let results: [Pokemon]    // 포켓몬 기본 정보 배열
}

struct Pokemon: Decodable {
    let name: String          // 포켓몬 이름
    let url: String           // 포켓몬 상세 정보 URL
//    let imageURL: String
}

// MARK: - 포켓몬 디테일 API 응답 구조
struct PokemonDetail: Decodable {
    let id: Int               // 포켓몬 ID
    let name: String          // 포켓몬 이름
    let height: Int           // 포켓몬 키
    let weight: Int           // 포켓몬 몸무게
    let sprites: Sprites      // 포켓몬 이미지 정보
    let stats: [Stat]         // 포켓몬 능력치 배열
    let types: [PokemonType]  // 포켓몬 타입 배열
}

struct Sprites: Decodable {
    let frontDefault: String? // 포켓몬 기본 이미지 URL
    
    enum CodingKeys: String, CodingKey {
        case frontDefault = "front_default"
    }
}

struct Stat: Decodable {
    let baseStat: Int         // 능력치 값
    let stat: StatDetail      // 능력치 상세 정보
    
    enum CodingKeys: String, CodingKey {
        case baseStat = "base_stat"
        case stat
    }
}

struct StatDetail: Decodable {
    let name: String          // 능력치 이름 (e.g., speed, attack, defense)
}

struct PokemonType: Decodable {
    let type: TypeDetail      // 타입 상세 정보
}

struct TypeDetail: Decodable {
    let name: String          // 타입 이름 (e.g., fire, water, grass)
}

