import UIKit
import RxSwift
import RxCocoa
import Alamofire
import AlamofireImage

extension UIImageView {
    func download(urlPath: String?) {
        guard let urlPath = urlPath, let url = URL(string: urlPath) else { return }
        af_setImage(withURL: url)
    }
}


extension Reactive where Base: UIImageView {
    var download: Binder<String> {
        return Binder(base) { imageView, imageEndpoint in
            imageView.download(urlPath: imageEndpoint)
        }
    }
}
