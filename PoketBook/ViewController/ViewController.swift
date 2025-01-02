import UIKit
import RxSwift
import RxCocoa

final class MainViewController: UIViewController {
    private let viewModel = MainViewModel()
    private let disposeBag = DisposeBag()
    
    // MARK: - UI Components
    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = 16
        layout.minimumInteritemSpacing = 8
        layout.sectionInset = UIEdgeInsets(top: 16, left: 16, bottom: 16, right: 16)
        
        let itemWidth = (UIScreen.main.bounds.width - 48) / 3
        layout.itemSize = CGSize(width: itemWidth, height: itemWidth)
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(PokemonCollectionViewCell.self, forCellWithReuseIdentifier: PokemonCollectionViewCell.identifier)
        collectionView.backgroundColor = UIColor.mainRed
        return collectionView
    }()
    
    // MARK: - UI Components
    private let pokemonBallImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "pokemonBall") // pokemonBall 이미지를 설정하세요.
        imageView.contentMode = .scaleAspectFit // 이미지 비율 유지
        return imageView
    }()
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 배경색을 빨간색으로 설정
        view.backgroundColor = UIColor.mainRed
        
        setupUI()
        bindViewModel()
        viewModel.fetchPokemonListTrigger.onNext(())
    }
    
    private func setupUI() {
        // pokemonBallImageView를 view에 추가
        view.addSubview(pokemonBallImageView)
        
        // Auto Layout 설정
        pokemonBallImageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            pokemonBallImageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10), // 상단 여백
            pokemonBallImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor), // 가로 중앙
            pokemonBallImageView.widthAnchor.constraint(equalToConstant: 100), // 이미지 크기 설정
            pokemonBallImageView.heightAnchor.constraint(equalToConstant: 100) // 이미지 크기 설정
        ])
        
        // collectionView를 view에 추가
        view.addSubview(collectionView)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: pokemonBallImageView.bottomAnchor, constant: 16), // pokemonBall 아래에 위치
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    private func bindViewModel() {
        // 기존 데이터 바인딩
        viewModel.pokemonList
            .bind(to: collectionView.rx.items(cellIdentifier: PokemonCollectionViewCell.identifier, cellType: PokemonCollectionViewCell.self)) { index, pokemon, cell in
                // 셀에 데이터를 전달
                cell.configure(with: pokemon, id: index + 1)  // 'pokemon.koreanName'을 표시할 수 있도록
            }
            .disposed(by: disposeBag)
        
        // 무한 스크롤 트리거
        collectionView.rx.contentOffset
            .filter { [weak self] offset in
                guard let self = self else { return false }
                let contentHeight = self.collectionView.contentSize.height
                let frameHeight = self.collectionView.frame.size.height
                return offset.y > contentHeight - frameHeight - 100 // 바닥 근처에서 트리거
            }
            .distinctUntilChanged()
            .subscribe(onNext: { [weak self] _ in
                self?.viewModel.fetchPokemonListTrigger.onNext(())
            })
            .disposed(by: disposeBag)
        
        // 아이템 선택 이벤트 처리
        collectionView.rx.itemSelected
            .subscribe(onNext: { [weak self] indexPath in
                guard let self = self else { return }
                self.viewModel.fetchPokemonDetail(id: indexPath.item + 1)
                    .observe(on: MainScheduler.instance)
                    .subscribe(onSuccess: { pokemonDetail in
                        let viewModel = DetailViewModel(pokemonDetail: pokemonDetail)
                        let detailVC = DetailViewController(viewModel: viewModel)
                        self.navigationController?.pushViewController(detailVC, animated: true)
                    }, onError: { error in
                        print("Error loading details: \(error.localizedDescription)")
                    })
                    .disposed(by: self.disposeBag)
            })
            .disposed(by: disposeBag)
    }
}
