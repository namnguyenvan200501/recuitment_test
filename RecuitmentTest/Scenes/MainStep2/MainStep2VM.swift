
import Foundation
import RxSwift
import RxCocoa

protocol MainStep2Delegate: AnyObject {
    func didTapButtonFromStep2(step: MainStep2Step)
}

enum MainStep2Step {
    case back
    case next
}

class MainStep2VM: ViewModel {
    
    var delegate: MainStep2Delegate?
    
    fileprivate let previousTapped = PublishRelay<Void>()
    fileprivate let nextTapped = PublishRelay<Void>()
    fileprivate let restaurantTapped = PublishRelay<UITapGestureRecognizer>()
    
    fileprivate let restaurantList: BehaviorRelay<[String]>
    fileprivate let restaurantSelected = BehaviorRelay<String>(value: "")
    
    fileprivate let error = PublishRelay<ErrorModel>()
    
    init(delegate: MainStep2Delegate?, metal: Metal) {
        let restaurantByMetal = globalDishes.filter({$0.availableMeals?.contains(metal.stringValue.lowercased()) == true})
        let uniqRestaurant = Set(restaurantByMetal.map({$0.restaurant ?? ""}))
        restaurantList = .init(value: uniqRestaurant.sorted())
        self.delegate = delegate
        super.init()
        setupRx()
    }
    
    private func setupRx() {
        previousTapped
            .subscribe(with: self) { vm, _ in
                vm.delegate?.didTapButtonFromStep2(step: .back)
            }
            .disposed(by: disposeBag)
        nextTapped
            .subscribe(with: self) { vm, _ in
                vm.delegate?.didTapButtonFromStep2(step: .next)
            }
            .disposed(by: disposeBag)
        
        restaurantTapped
            .subscribe(with: self) { vm, _ in
                guard !vm.restaurantList.value.isEmpty else {
                    vm.error.accept(ErrorModel(message: "List empty"))
                    return
                }
                showPicker(delegate: self, current: vm.restaurantSelected.value,
                           list: vm.restaurantList.value.map({ item in
                    return (item, true)
                }))
            }
            .disposed(by: disposeBag)
    }
    
    func getData() -> String? {
        guard !restaurantSelected.value.isEmpty else {
            error.accept(ErrorModel(message: "Please select restaurant"))
            return nil
        }
        return restaurantSelected.value
    }
}

extension Reactive where Base: Inputs<MainStep2VM> {
    var previousTapped: AnyObserver<Void> {
        return base.vm.previousTapped.asObserver()
    }
    var nextTapped: AnyObserver<Void> {
        return base.vm.nextTapped.asObserver()
    }
    var restaurantTapped: AnyObserver<UITapGestureRecognizer> {
        return base.vm.restaurantTapped.asObserver()
    }
}

extension Reactive where Base: Outputs<MainStep2VM> {
    var restaurantSelected: BehaviorRelay<String> {
        return base.vm.restaurantSelected
    }
    var error: Signal<ErrorModel> {
        return base.vm.error.asSignal()
    }
}

extension MainStep2VM: PickerVCDelegate {
    func pickerVC(didSelected: String) {
        restaurantSelected.accept(didSelected)
    }
}
