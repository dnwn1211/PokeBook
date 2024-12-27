import UIKit
import RxSwift
import RxCocoa
import Kingfisher

class MainViewController: UIViewController {
    private let viewModel = MainViewModel()
    private let disposeBag = DisposeBag()
    
    private let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: UIScreen.main.bounds.width / 3 - 10, height: 150)
        layout.minimumInteritemSpacing = 5
        layout.minimumLineSpacing = 10
        layout.sectionInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(PokemonCell.self, forCellWithReuseIdentifier: "PokemonCell")
        collectionView.backgroundColor = .white
        return collectionView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        bindViewModel()
        viewModel.fetchPokemonList()
    }
    
    private func setupUI() {
        title = "Pokédex"
        view.addSubview(collectionView)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.topAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    private func bindViewModel() {
        // Bind Pokémon list to the collectionView
        viewModel.pokemonList
            .bind(to: collectionView.rx.items(cellIdentifier: "PokemonCell", cellType: PokemonCell.self)) { row, pokemon, cell in
                cell.configure(with: pokemon)
            }
            .disposed(by: disposeBag)
        
        // Observe loading state
        viewModel.isLoading
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { isLoading in
                if isLoading {
                    print("Loading...")
                } else {
                    print("Finished loading.")
                }
            })
            .disposed(by: disposeBag)
        
        // Observe error messages
        viewModel.errorMessage
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { message in
                print("Error: \(message)")
            })
            .disposed(by: disposeBag)
    }
}
