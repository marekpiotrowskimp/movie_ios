import UIKit
import RxSwift
import RxCocoa

class HomeViewController: UIViewController {
    
    // MARK: - HomeViewController Properties
    
    private let disposeBag = DisposeBag()
    private lazy var moviesTableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.register(MovieCell.self, forCellReuseIdentifier: MovieCell.identifier)
        tableView.separatorStyle = .none
        tableView.backgroundColor = UIColor(named: "background")
        return tableView
    }()
    
    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.itemSize = CGSize(width: 106, height: 160)
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 0
        let collectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: layout)
        collectionView.register(MoviePlayingCell.self, forCellWithReuseIdentifier: MoviePlayingCell.identifier)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.backgroundColor = UIColor(named: "background")
        return collectionView
    }()
    
    private lazy var playingNowHeader: HeaderView = {
        let header = HeaderView()
        header.headerLabel.text = "Playing now"
        return header
    }()
    
    private lazy var popularHeader: HeaderView = {
        let header = HeaderView()
        header.headerLabel.text = "Most popular"
        return header
    }()
    
    private let viewModel: HomeViewModelProtocol
    
    // MARK: - Initialization
    
    init(viewModel: HomeViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationBar()
        view.addSubview(playingNowHeader)
        view.addSubview(collectionView)
        view.addSubview(popularHeader)
        view.addSubview(moviesTableView)
        setupConstraints()
        setupDataSource()
    }
    
    // MARK: - Setup UI
    
    private func setupNavigationBar() {
        let logo = UIImage(named: "MovieBox")
        let imageView = UIImageView(image:logo)
        self.navigationItem.titleView = imageView
        
        let appearance = UINavigationBarAppearance()
        appearance.backgroundColor = UIColor(named: "background")
        appearance.titleTextAttributes = [.foregroundColor: UIColor.white]
        appearance.largeTitleTextAttributes = [.foregroundColor: UIColor.white]

        navigationController?.navigationBar.tintColor = .white
        navigationController?.navigationBar.standardAppearance = appearance
        navigationController?.navigationBar.compactAppearance = appearance
        navigationController?.navigationBar.scrollEdgeAppearance = appearance
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            playingNowHeader.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            playingNowHeader.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            playingNowHeader.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            
            collectionView.topAnchor.constraint(equalTo: playingNowHeader.bottomAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.heightAnchor.constraint(equalToConstant: 160),
            
            popularHeader.topAnchor.constraint(equalTo: collectionView.bottomAnchor),
            popularHeader.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            popularHeader.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            
            moviesTableView.topAnchor.constraint(equalTo: popularHeader.bottomAnchor),
            moviesTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            moviesTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            moviesTableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    // MARK: Setup DataSources
    
    private func setupDataSource() {
        setupMoviePlayingDataSource()
        setupMovieDataSource()
    }
    
    private func setupMoviePlayingDataSource() {
        let moviePlayingDataSource = MoviePlayingDataSource { collectionView, viewModel, indexPath in
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MoviePlayingCell.identifier, for: indexPath) as? MoviePlayingCell
            cell?.configure(viewModel: viewModel)
            return cell ?? UICollectionViewCell()
        } selected: { [weak self] viewModel in
            guard let movieId = viewModel.movie.id else { return }
            self?.viewModel.showMovieDetails(movieId: movieId)
        }
        collectionView.delegate = moviePlayingDataSource
        viewModel.getPlayingMovies()
            .map { result in
                switch result {
                    case .success(let movies):
                    return movies.movies?.map { MoviePlayingCellViewModel(movie: $0) } ?? []
                    case .failure(_):
                    return [MoviePlayingCellViewModel]()
                }
            }
            .bind(to: collectionView.rx.items(dataSource: moviePlayingDataSource))
            .disposed(by: disposeBag)
    }
    
    private func setupMovieDataSource() {
        let movieDataSource = MovieDataSource { tableView, movieCellViewModel, indexPath in
            let cell = tableView.dequeueReusableCell(withIdentifier: "MovieCell",
                                                               for: indexPath) as? MovieCell
            cell?.configure(viewModel: movieCellViewModel)
            return cell ?? UITableViewCell()
        } fetchNext: { [weak self] in
            self?.viewModel.fetchNext()
        } selected: { [weak self] movieCellViewModel in
            guard let movieId = movieCellViewModel.movie.id else { return }
            self?.viewModel.showMovieDetails(movieId: movieId)
        }

        moviesTableView.delegate = movieDataSource
        viewModel.getMovies()
            .map { result in
                switch result {
                    case .success(let movies):
                    return movies.movies?.map { MovieCellViewModel(movie: $0) } ?? []
                    case .failure(_):
                    return [MovieCellViewModel]()
                }
            }
            .bind(to: moviesTableView.rx.items(dataSource: movieDataSource))
            .disposed(by: disposeBag)
    }
    

}
