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
    
    private let pokemonBallImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "pokemonBall") // pokemonBall 이미지를 설정하세요.
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private let loadingIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .large)
        indicator.color = .white
        indicator.hidesWhenStopped = true
        return indicator
    }()
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor.mainRed
        
        setupUI()
        bindViewModel()
        
        // 로딩 화면 시작
        loadingIndicator.startAnimating()
        viewModel.fetchPokemonListTrigger.onNext(())
    }
    
    private func setupUI() {
        view.addSubview(pokemonBallImageView)
        view.addSubview(collectionView)
        view.addSubview(loadingIndicator)
        
        pokemonBallImageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            pokemonBallImageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10),
            pokemonBallImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            pokemonBallImageView.widthAnchor.constraint(equalToConstant: 100),
            pokemonBallImageView.heightAnchor.constraint(equalToConstant: 100)
        ])
        
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: pokemonBallImageView.bottomAnchor, constant: 16),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        
        // 로딩 인디케이터 레이아웃 설정
        loadingIndicator.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            loadingIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            loadingIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
    
    private func bindViewModel() {
        // 기존 데이터 바인딩
        viewModel.pokemonList
            .bind(to: collectionView.rx.items(cellIdentifier: PokemonCollectionViewCell.identifier, cellType: PokemonCollectionViewCell.self)) { index, pokemon, cell in
                cell.configure(with: pokemon, id: index + 1)
            }
            .disposed(by: disposeBag)
        
        // 무한 스크롤 트리거
        collectionView.rx.contentOffset
            .filter { [weak self] offset in
                guard let self = self else { return false }
                let contentHeight = self.collectionView.contentSize.height
                let frameHeight = self.collectionView.frame.size.height
                return offset.y > contentHeight - frameHeight - 100
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
        
        // 이미지 로딩이 완료되면 로딩 인디케이터를 숨김
        viewModel.pokemonList
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] _ in
                self?.loadingIndicator.stopAnimating()
            })
            .disposed(by: disposeBag)
    }
}
