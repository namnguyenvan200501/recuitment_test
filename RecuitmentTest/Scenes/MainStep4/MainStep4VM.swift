
import Foundation
import RxSwift
import RxCocoa

protocol MainStep4Delegate: AnyObject {
    func didTapButtonFromStep4()
}

struct MainStep4Data {
    var medal: String
    var numOfPeople: Int
    var restaurant: String
    var dishes: [OrderDishModel]
    
    init(medal: String, numOfPeople: Int, restaurant: String, dishes: [OrderDishModel]) {
        self.medal = medal
        self.numOfPeople = numOfPeople
        self.restaurant = restaurant
        self.dishes = dishes
    }
}

class MainStep4VM: ViewModel {
    
    var delegate: MainStep4Delegate?
    
    fileprivate let previousTapped = PublishRelay<Void>()
    
    fileprivate let data: BehaviorRelay<MainStep4Data?>
    
    init(delegate: MainStep4Delegate?, data: MainStep4Data?) {
        self.delegate = delegate
        self.data = .init(value: data)
        super.init()
        setupRx()
    }
    
    private func setupRx() {
        previousTapped
            .subscribe(with: self) { vm, _ in
                vm.delegate?.didTapButtonFromStep4()
            }
            .disposed(by: disposeBag)
    }
}

extension Reactive where Base: Inputs<MainStep4VM> {
    var previousTapped: AnyObserver<Void> {
        return base.vm.previousTapped.asObserver()
    }
}

extension Reactive where Base: Outputs<MainStep4VM> {
    var data: BehaviorRelay<MainStep4Data?> {
        return base.vm.data
    }
}
