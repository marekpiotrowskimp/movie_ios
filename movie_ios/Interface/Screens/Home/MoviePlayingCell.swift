import UIKit
import RxSwift
import RxCocoa

class MoviePlayingCell: UICollectionViewCell {
    
    //
    // MARK: - Class Constants
    //
    static let identifier = "MoviePlayingCell"
    private var disposeBag = DisposeBag()
    private var viewModel: MoviePlayingCellViewModel?
    
    private(set) lazy var poster: UIImageView = {
        let imageView = UIImageView()
        return imageView
    }()
    
    // MARK: - Initialization
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Setup UI
    
    private func setupUI() {
        [poster].forEach { view in
            addSubview(view)
            view.translatesAutoresizingMaskIntoConstraints = false
        }
        backgroundColor = UIColor(named: "light_gray")
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            poster.topAnchor.constraint(equalTo: topAnchor),
            poster.bottomAnchor.constraint(equalTo: bottomAnchor),
            poster.leadingAnchor.constraint(equalTo: leadingAnchor),
            poster.trailingAnchor.constraint(equalTo: trailingAnchor),
            poster.widthAnchor.constraint(equalToConstant: 106),
            poster.heightAnchor.constraint(equalToConstant: 160)
        ])
    }
    
    // MARK: Reactive Bindings
    
    private func setupBindings() {
        disposeBag = DisposeBag()
        
        viewModel?.posterPathObservable
            .map { MovieImageEndpoint(posterPath: $0).urlPath }
            .bind(to: poster.rx.download)
            .disposed(by: disposeBag)
    }
    
    // MARK: - Cell configuration
    
    func configure(viewModel: MoviePlayingCellViewModel) {
        self.viewModel = viewModel
        setupBindings()
    }
}
