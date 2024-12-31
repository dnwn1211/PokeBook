import UIKit
import Kingfisher

final class DetailViewController: UIViewController {
    private let viewModel: DetailViewModel

    // MARK: - UI Components
    private lazy var cardView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 16
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOpacity = 0.1
        view.layer.shadowOffset = CGSize(width: 0, height: 4)
        view.layer.shadowRadius = 8
        return view
    }()

    private lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true
        return imageView
    }()

    private lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.font = .boldSystemFont(ofSize: 20)
        label.textAlignment = .center
        return label
    }()

    private lazy var typeLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16)
        label.textAlignment = .center
        return label
    }()

    private lazy var heightLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16)
        label.textAlignment = .center
        return label
    }()

    private lazy var weightLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16)
        label.textAlignment = .center
        return label
    }()

    // MARK: - Initializer
    init(viewModel: DetailViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(red: 245/255, green: 245/255, blue: 235/255, alpha: 1.0)
        setupUI()
        bindViewModel()
    }

    private func setupUI() {
        // Add card view to main view
        view.addSubview(cardView)
        cardView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            cardView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            cardView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            cardView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.8),
            cardView.heightAnchor.constraint(equalToConstant: 300)
        ])

        // Add components to card view
        [imageView, nameLabel, typeLabel, heightLabel, weightLabel].forEach { cardView.addSubview($0) }

        imageView.translatesAutoresizingMaskIntoConstraints = false
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        typeLabel.translatesAutoresizingMaskIntoConstraints = false
        heightLabel.translatesAutoresizingMaskIntoConstraints = false
        weightLabel.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: cardView.topAnchor, constant: 16),
            imageView.centerXAnchor.constraint(equalTo: cardView.centerXAnchor),
            imageView.widthAnchor.constraint(equalToConstant: 100),
            imageView.heightAnchor.constraint(equalToConstant: 100),

            nameLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 16),
            nameLabel.leadingAnchor.constraint(equalTo: cardView.leadingAnchor, constant: 16),
            nameLabel.trailingAnchor.constraint(equalTo: cardView.trailingAnchor, constant: -16),

            typeLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 8),
            typeLabel.leadingAnchor.constraint(equalTo: cardView.leadingAnchor, constant: 16),
            typeLabel.trailingAnchor.constraint(equalTo: cardView.trailingAnchor, constant: -16),

            heightLabel.topAnchor.constraint(equalTo: typeLabel.bottomAnchor, constant: 8),
            heightLabel.leadingAnchor.constraint(equalTo: cardView.leadingAnchor, constant: 16),
            heightLabel.trailingAnchor.constraint(equalTo: cardView.trailingAnchor, constant: -16),

            weightLabel.topAnchor.constraint(equalTo: heightLabel.bottomAnchor, constant: 8),
            weightLabel.leadingAnchor.constraint(equalTo: cardView.leadingAnchor, constant: 16),
            weightLabel.trailingAnchor.constraint(equalTo: cardView.trailingAnchor, constant: -16)
        ])
    }

    private func bindViewModel() {
        if let url = viewModel.imageURL {
            imageView.kf.setImage(with: url) { result in
                switch result {
                case .success(let value):
                    print("Image loaded successfully: \(value.source.url?.absoluteString ?? "")")
                case .failure(let error):
                    print("Error loading image: \(error.localizedDescription)")
                }
            }
        }

        nameLabel.text = viewModel.name
        typeLabel.text = viewModel.type
        heightLabel.text = viewModel.height
        weightLabel.text = viewModel.weight
    }
}
