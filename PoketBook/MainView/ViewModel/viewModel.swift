import Foundation
import RxSwift
import RxRelay

final class MainViewModel {
    // MARK: - Properties
    private let disposeBag = DisposeBag()
    private let networkManager = NetworkManager.shared
    
    // Input
    let fetchPokemonListTrigger = PublishSubject<Void>() // 트리거
    
    // Output
    let pokemonList = BehaviorRelay<[Pokemon]>(value: []) // 포켓몬 리스트
    let error = PublishRelay<String>() // 에러 메시지
    let isLoading = BehaviorRelay<Bool>(value: false) // 로딩 상태
    
    private var offset = 0
    private let limit = 20
    
    // MARK: - Initialization
    init() {
        bindFetchPokemonList()
    }
    
    func fetchPokemonDetail(id: Int) -> Single<PokemonDetail> {
        let urlString = "https://pokeapi.co/api/v2/pokemon/\(id)/"
        guard let url = URL(string: urlString) else {
            return .error(NetworkError.invalidURL)
        }
        return NetworkManager.shared.fetch(url: url)
    }
    
    // MARK: - Methods
    private func bindFetchPokemonList() {
        fetchPokemonListTrigger
            .filter { [unowned self] in !self.isLoading.value } // 로딩 중이 아니어야 트리거 실행
            .do(onNext: { [unowned self] in self.isLoading.accept(true) }) // 로딩 시작
            .flatMapLatest { [unowned self] in
                self.fetchPokemonList(limit: self.limit, offset: self.offset)
            }
            .subscribe(onNext: { [weak self] result in
                guard let self = self else { return }
                self.isLoading.accept(false) // 로딩 종료
                switch result {
                case .success(let newPokemons):
                    // 기존 데이터와 새 데이터 병합
                    let updatedList = self.pokemonList.value + newPokemons
                    self.pokemonList.accept(updatedList)
                    self.offset += self.limit // 다음 데이터 요청을 위한 offset 증가
                case .failure(let error):
                    self.error.accept(error.localizedDescription)
                }
            }, onError: { [weak self] error in
                self?.isLoading.accept(false) // 로딩 종료
                self?.error.accept(error.localizedDescription)
            })
            .disposed(by: disposeBag)
    }
    
    private func fetchPokemonList(limit: Int, offset: Int) -> Observable<Result<[Pokemon], Error>> {
        let urlString = "https://pokeapi.co/api/v2/pokemon?limit=\(limit)&offset=\(offset)"
        guard let url = URL(string: urlString) else {
            return Observable.just(.failure(NetworkError.invalidURL))
        }
        
        return networkManager.fetch(url: url)
            .map { (response: PokemonListResponse) -> Result<[Pokemon], Error> in
                .success(response.results)
            }
            .catch { error in
                .just(.failure(error))
            }
            .asObservable()
    }
}
