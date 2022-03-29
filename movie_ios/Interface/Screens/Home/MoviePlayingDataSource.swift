import UIKit
import RxSwift
import RxCocoa

final class MoviePlayingDataSource: NSObject, UICollectionViewDataSource, UICollectionViewDelegate, RxCollectionViewDataSourceType {
    
    // MARK: - MoviePlayingDataSource properties
    
    typealias Element = [MoviePlayingCellViewModel]
    private var movies = [MoviePlayingCellViewModel]()
    private let selected: (MoviePlayingCellViewModel) -> Void

    private let cellConfigure: (UICollectionView, MoviePlayingCellViewModel, IndexPath) -> UICollectionViewCell
    
    // MARK: Initialization
    
    init(cellConfigure: @escaping (UICollectionView, MoviePlayingCellViewModel, IndexPath) -> UICollectionViewCell, selected: @escaping (MoviePlayingCellViewModel) -> Void) {
        self.cellConfigure = cellConfigure
        self.selected = selected
    }
    
    // MARK: RxCollectionViewDataSourceType
    
    func collectionView(_ collectionView: UICollectionView, observedEvent: Event<[MoviePlayingCellViewModel]>) {
        self.movies = observedEvent.element ?? []
        collectionView.reloadData()
    }
    
    // MARK: UICollectionViewDataSource
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        movies.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        return cellConfigure(collectionView, movies[indexPath.row], indexPath)
    }
    
    // MARK: UICollectionViewDelegate
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        selected(movies[indexPath.row])
    }
}
