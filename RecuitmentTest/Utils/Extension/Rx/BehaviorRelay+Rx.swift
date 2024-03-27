import Foundation
import RxSwift
import RxCocoa

extension BehaviorRelay {
    func asObserver() -> AnyObserver<Element> {
        return .init { [weak self] (event) in
            guard let element = event.element else { return }
            self?.accept(element)
        }
    }
}
