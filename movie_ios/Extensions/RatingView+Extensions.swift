import RxCocoa
import RxSwift

extension Reactive where Base: RatingView {
    var rating: Binder<Double> {
        return Binder(base) { ratingView, rating in
            ratingView.rating = rating
        }
    }
}
