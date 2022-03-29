import UIKit
import RxSwift
import RxCocoa

//
// MARK: - Movie Cell
//
class MovieCell: UITableViewCell {
    
    //
    // MARK: - Class Constants
    //
    static let identifier = "MovieCell"
    private final class Consts {
        static let posterTopMargin: CGFloat = 8
        static let posterBottomMargin: CGFloat = -7
        static let posterLeadingMargin: CGFloat = 25
        static let posterWidth: CGFloat = 49
        static let posterHeight: CGFloat = 73
        static let labelsLeadingMargin: CGFloat = 18
        static let labelsTopMargin: CGFloat = 7
        static let labelsWidth: CGFloat = 220
        static let titleTopMargin: CGFloat = 16
        static let ratingTrailingMargin: CGFloat = -25
        static let ratingSize: CGFloat = 38
        static let cellBottomSpace: CGFloat = -5
    }
    
    //
    // MARK: - Cell propertice
    //
    private var disposeBag = DisposeBag()
    private var viewModel: MovieCellViewModel?
    
    // MARK: - Cell UI Components
    
    private lazy var title: UILabel = {
        let label = UILabel()
        label.font = Fonts.bold14
        label.textColor = UIColor(named: "text_gray")
        return label
    }()
    
    private lazy var releaseDate: UILabel = {
        let label = UILabel()
        label.font = Fonts.small12
        label.textColor = UIColor(named: "text_gray")
        return label
    }()
    
    private lazy var duration: UILabel = {
        let label = UILabel()
        label.font = Fonts.small12
        label.textColor = UIColor(named: "text_gray")
        return label
    }()
    
    private lazy var rating: RatingView = {
        RatingView()
    }()
    
    private lazy var poster: UIImageView = {
        let imageView = UIImageView()
        imageView.layer.borderColor = UIColor(named: "border")?.cgColor
        imageView.layer.borderWidth = 1
        return imageView
    }()
    
    private lazy var container: UIView = {
        UIView()
    }()
    
    //
    // MARK: - Cell initialisation
    //
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Cell UI Setup
    
    private func setupUI() {
        [title, releaseDate, rating, poster, duration].forEach { view in
            container.addSubview(view)
            view.translatesAutoresizingMaskIntoConstraints = false
        }
        container.translatesAutoresizingMaskIntoConstraints = false
        addSubview(container)
        container.backgroundColor = UIColor(named: "background")
        backgroundColor = UIColor(named: "light_gray")
        let bgColorView = UIView()
        bgColorView.backgroundColor = UIColor(named: "text_yellow")
        selectedBackgroundView = bgColorView
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            poster.topAnchor.constraint(equalTo: container.topAnchor, constant: Consts.posterTopMargin),
            poster.bottomAnchor.constraint(equalTo: container.bottomAnchor, constant: Consts.posterBottomMargin),
            poster.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: Consts.posterLeadingMargin),
            poster.widthAnchor.constraint(equalToConstant: Consts.posterWidth),
            poster.heightAnchor.constraint(equalToConstant: Consts.posterHeight),
            
            title.topAnchor.constraint(equalTo: container.topAnchor, constant: Consts.titleTopMargin),
            title.leadingAnchor.constraint(equalTo: poster.trailingAnchor, constant: Consts.labelsLeadingMargin),
            title.widthAnchor.constraint(equalToConstant: Consts.labelsWidth),
            
            releaseDate.topAnchor.constraint(equalTo: title.bottomAnchor, constant: Consts.labelsTopMargin),
            releaseDate.leadingAnchor.constraint(equalTo: poster.trailingAnchor, constant: Consts.labelsLeadingMargin),
            releaseDate.widthAnchor.constraint(equalToConstant: Consts.labelsWidth),
            
            duration.topAnchor.constraint(equalTo: releaseDate.bottomAnchor, constant: Consts.labelsTopMargin),
            duration.leadingAnchor.constraint(equalTo: poster.trailingAnchor, constant: Consts.labelsLeadingMargin),
            duration.widthAnchor.constraint(equalToConstant: Consts.labelsWidth),
            
            rating.centerYAnchor.constraint(equalTo: container.centerYAnchor),
            rating.trailingAnchor.constraint(equalTo: container.trailingAnchor, constant: Consts.ratingTrailingMargin),
            rating.widthAnchor.constraint(equalToConstant: Consts.ratingSize),
            rating.heightAnchor.constraint(equalToConstant: Consts.ratingSize),
            
            container.topAnchor.constraint(equalTo: topAnchor),
            container.bottomAnchor.constraint(equalTo: bottomAnchor, constant: Consts.cellBottomSpace),
            container.leadingAnchor.constraint(equalTo: leadingAnchor),
            container.trailingAnchor.constraint(equalTo: trailingAnchor)
        ])
    }
    
    // MARK: Reactive Bindings
    
    private func setupBindings() {
        disposeBag = DisposeBag()
        
        viewModel?.titleObservable
            .bind(to: title.rx.text)
            .disposed(by: disposeBag)
        
        viewModel?.releaseDateObservable
            .bind(to: releaseDate.rx.text)
            .disposed(by: disposeBag)
        
        viewModel?.durationObservable
            .bind(to: duration.rx.text)
            .disposed(by: disposeBag)
        
        viewModel?.voteAverageObservable
            .map { ($0 ?? 0) * 10 }
            .bind(to: rating.rx.rating)
            .disposed(by: disposeBag)
        
        viewModel?.posterPathObservable
            .map { MovieImageEndpoint(posterPath: $0).urlPath }
            .bind(to: poster.rx.download)
            .disposed(by: disposeBag)
    }
    
    // MARK: - Cell configuration
    
    func configure(viewModel: MovieCellViewModel) {
        self.viewModel = viewModel
        setupBindings()
    }
}
