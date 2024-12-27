import Foundation
import RxSwift
import RxRelay

class MainViewModel {
    let pokemonList: BehaviorRelay<[PokemonListEntry]> = BehaviorRelay(value: [])
    let isLoading: BehaviorRelay<Bool> = BehaviorRelay(value: false)
    let errorMessage: PublishRelay<String> = PublishRelay()
    private let disposeBag = DisposeBag()
    
    func fetchPokemonList(limit: Int = 20, offset: Int = 0) {
        isLoading.accept(true)
        NetworkManager.shared.fetchPokemonList(limit: limit, offset: offset) { [weak self] result in
            guard let self = self else { return }
            self.isLoading.accept(false)
            
            switch result {
            case .success(let response):
                self.pokemonList.accept(response.results)
            case .failure(let error):
                self.errorMessage.accept("Failed to load Pokémon: \(error.localizedDescription)")
            }
        }
    }
}
