import UIKit
import RxSwift
import RxCocoa

class MovieDataSource: NSObject, UITableViewDataSource, UITableViewDelegate, RxTableViewDataSourceType {
    
    // MARK: - MovieDataSource properties
    
    typealias Element = [MovieCellViewModel]
    private var moviesPopular = [MovieCellViewModel]()
    private let cellConfigure: (UITableView, MovieCellViewModel, IndexPath) -> UITableViewCell
    private let fetchNext: () -> Void
    private let selected: (MovieCellViewModel) -> Void
    
    // MARK: - Initialization
    
    init(cellConfigure: @escaping (UITableView, MovieCellViewModel, IndexPath) -> UITableViewCell,
         fetchNext: @escaping () -> Void,
         selected: @escaping (MovieCellViewModel) -> Void) {
        self.cellConfigure = cellConfigure
        self.fetchNext = fetchNext
        self.selected = selected
    }
    
    // MARK: - RxTableViewDataSourceType
    
    func tableView(_ tableView: UITableView, observedEvent: Event<[MovieCellViewModel]>) {
        self.moviesPopular += (observedEvent.element ?? [])
        tableView.reloadData()
    }
    
    // MARK: - UITableViewDataSource
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        self.moviesPopular.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let movieViewModel = self.moviesPopular[indexPath.row]
        return cellConfigure(tableView, movieViewModel, indexPath)
    }
    
    // MARK: - UITableViewDelegate
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let maxCount = self.moviesPopular.count - 4
        if maxCount == indexPath.row {
            fetchNext()
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let movieViewModel = self.moviesPopular[indexPath.row]
        selected(movieViewModel)
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
