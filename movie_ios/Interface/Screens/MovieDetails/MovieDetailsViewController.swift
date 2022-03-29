import UIKit
import RxSwift
import RxCocoa
import RxGesture

class MovieDetailsViewController: UIViewController {
    
    // MARK: - HomeViewController Properties
    
    private let viewModel: MovieDetailsViewModelProtocol
    private let disposeBag = DisposeBag()
    
    // MARK: - Setup UI Components
    
    private lazy var closeButton: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "close")
        imageView.isUserInteractionEnabled = true
        imageView.backgroundColor = .black
        return imageView
    }()
    
    private lazy var movieTitle: UILabel = {
        let label = UILabel()
        label.font = Fonts.bold14
        label.textColor = UIColor(named: "text_gray")
        return label
    }()
    
    private lazy var releaseDateAndRunTimeLabel: UILabel = {
        let label = UILabel()
        label.font = Fonts.small12
        label.textColor = UIColor(named: "text_gray")
        return label
    }()
    
    private lazy var descriptionData: UILabel = {
        let label = UILabel()
        label.font = Fonts.small12
        label.textAlignment = .justified
        label.textColor = UIColor(named: "text_gray")
        label.numberOfLines = 0
        return label
    }()
    
    private lazy var overviewLabel: UILabel = {
        let label = UILabel()
        label.font = Fonts.bold14
        label.textColor = UIColor(named: "text_gray")
        label.text = "Overview"
        return label
    }()
    
    private lazy var poster: UIImageView = {
        let imageView = UIImageView()
        imageView.layer.borderColor = UIColor(named: "border")?.cgColor
        imageView.layer.borderWidth = 1
        return imageView
    }()
    
    private lazy var genreStack: UIStackView = {
        let genreStack = UIStackView()
        genreStack.axis = .horizontal
        genreStack.spacing = 2
        genreStack.alignment = .center
        genreStack.distribution = .fillProportionally
        return genreStack
    }()
    
    // MARK: - Setup Binders
    
    var genreStackBinder: Binder<[Genre]> {
        func createGenreLabel(text: String?) -> UILabel {
            let label = UILabel()
            label.font = Fonts.bold12
            label.textColor = UIColor(named: "black")
            label.backgroundColor = UIColor(named: "white")
            label.layer.cornerRadius = 2
            label.clipsToBounds = true
            label.textAlignment = .center
            return label
        }
        return Binder(genreStack) { genreStackView, genres in
            genres.forEach { genre in
                let label = createGenreLabel(text: genre.name)
                genreStackView.addArrangedSubview(label)
            }
        }
    }
    
    // MARK: - Initialization
    
    init(viewModel: MovieDetailsViewModelProtocol) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        setupUI()
        setupConstraints()
        setupBindings()
        viewModel.getMovieDetails()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Setup UI
    
    private func setupUI() {
        view.backgroundColor = UIColor(named: "dimmed")
        [closeButton, movieTitle, releaseDateAndRunTimeLabel, poster, descriptionData, overviewLabel, genreStack].forEach { addView in
            view.addSubview(addView)
            addView.translatesAutoresizingMaskIntoConstraints = false
        }
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            closeButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 31),
            closeButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -35),
            closeButton.widthAnchor.constraint(equalToConstant: 24),
            closeButton.heightAnchor.constraint(equalToConstant: 24),
            
            poster.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 75),
            poster.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            poster.widthAnchor.constraint(equalToConstant: 135),
            poster.heightAnchor.constraint(equalToConstant: 201),
            
            movieTitle.topAnchor.constraint(equalTo: poster.bottomAnchor, constant: 6),
            movieTitle.centerXAnchor.constraint(equalTo: poster.centerXAnchor),
            
            releaseDateAndRunTimeLabel.topAnchor.constraint(equalTo: movieTitle.bottomAnchor, constant: 6),
            releaseDateAndRunTimeLabel.centerXAnchor.constraint(equalTo: poster.centerXAnchor),
            
            overviewLabel.topAnchor.constraint(equalTo: releaseDateAndRunTimeLabel.bottomAnchor, constant: 20),
            overviewLabel.leadingAnchor.constraint(equalTo: descriptionData.leadingAnchor),
            
            descriptionData.topAnchor.constraint(equalTo: overviewLabel.bottomAnchor, constant: 20),
            descriptionData.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            descriptionData.widthAnchor.constraint(equalToConstant: 293),

            genreStack.topAnchor.constraint(equalTo: descriptionData.bottomAnchor, constant: 20),
            genreStack.leadingAnchor.constraint(equalTo: descriptionData.leadingAnchor),
            genreStack.trailingAnchor.constraint(equalTo: descriptionData.trailingAnchor)
        ])
    }
    
    // MARK: Setup Bindings
    
    private func setupBindings() {
        
        viewModel.titleObservable
            .bind(to: movieTitle.rx.text)
            .disposed(by: disposeBag)
        
        viewModel.releaseDateAndRunTimeObservable
            .bind(to: releaseDateAndRunTimeLabel.rx.text)
            .disposed(by: disposeBag)
        
        viewModel.posterPathObservable
            .map { MovieImageEndpoint(posterPath: $0).urlPath }
            .bind(to: poster.rx.download)
            .disposed(by: disposeBag)
        
        viewModel.descriptionObservable
            .bind(to: descriptionData.rx.text)
            .disposed(by: disposeBag)
        
        viewModel.genreObservable
            .skip(1)
            .bind(to: genreStackBinder)
            .disposed(by: disposeBag)
        
        closeButton.rx.tapGesture().when(.recognized)
            .subscribe(onNext: { [weak self] _ in
            self?.dismiss(animated: true)
        }).disposed(by: disposeBag)
    }
}
