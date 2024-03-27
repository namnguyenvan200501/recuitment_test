
import Foundation
import RxSwift
import RxCocoa

protocol MainStep3Delegate: AnyObject {
    func didTapButtonFromStep3(step: MainStep3Step)
}


enum MainStep3Step {
    case back
    case next
}

class MainStep3VM: ViewModel {
    
    var delegate: MainStep3Delegate?
    
    fileprivate let previousTapped = PublishRelay<Void>()
    fileprivate let nextTapped = PublishRelay<Void>()
    fileprivate let dishTapped = PublishRelay<(UITapGestureRecognizer, Int)>()
    
    fileprivate let numberOrderChange = PublishRelay<(Int, Int)>()
    
    fileprivate let increaseTapped = PublishRelay<Int>()
    fileprivate let decreaseTapped = PublishRelay<Int>()
    
    fileprivate let addTapped = PublishRelay<Void>()
    
    fileprivate let order = BehaviorRelay<[OrderDishModel]>(value: [OrderDishModel()])
    
    fileprivate let editingIndex = BehaviorRelay<Int>(value: -1)
    
    fileprivate let dishList: BehaviorRelay<[String]>
    
    fileprivate let error = PublishRelay<ErrorModel>()
    
    init(delegate: MainStep3Delegate?, metal: Metal, restaurant: String) {
        let dishByMetalAndRestaurant = globalDishes.filter({$0.availableMeals?.contains(metal.stringValue.lowercased()) == true && $0.restaurant?.elementsEqual(restaurant) == true})
        let uniqDish = Set(dishByMetalAndRestaurant.map({$0.name ?? ""}))
        self.dishList = .init(value: uniqDish.sorted())
        self.delegate = delegate
        super.init()
        setupRx()
    }
    
    private func setupRx() {
        previousTapped
            .subscribe(with: self) { vm, _ in
                vm.delegate?.didTapButtonFromStep3(step: .back)
            }
            .disposed(by: disposeBag)
        nextTapped
            .subscribe(with: self) { vm, _ in
                vm.delegate?.didTapButtonFromStep3(step: .next)
            }
            .disposed(by: disposeBag)
        
        addTapped
            .subscribe(with: self) { vm, _ in
                vm.order.accept(vm.order.value + [OrderDishModel()])
            }
            .disposed(by: disposeBag)
        
        dishTapped
            .subscribe(with: self) { vm, result in
                guard !vm.dishList.value.isEmpty else {
                    vm.error.accept(ErrorModel(message: "List empty"))
                    return
                }
                vm.editingIndex.accept(result.1)
                showPicker(delegate: self, current: vm.order.value[result.1].name,
                           list: vm.dishList.value.map({ item in
                    return (item, true)
                }))
            }
            .disposed(by: disposeBag)
        
        numberOrderChange
            .subscribe(with: self) { vm, result in
                let (num, index) = result
                guard !vm.order.value.isEmpty, index < vm.order.value.count else { return }
                var list = vm.order.value
                list[index].updateNumber(number: num)
                vm.order.accept(list)
            }
            .disposed(by: disposeBag)
        
        increaseTapped
            .subscribe(with: self) { vm, index in
                guard index < vm.order.value.count else { return }
                var list = vm.order.value
                list[index].updateNumber(number: list[index].number + 1)
                vm.order.accept(list)
            }
            .disposed(by: disposeBag)
        
        decreaseTapped
            .subscribe(with: self) { vm, index in
                guard index < vm.order.value.count else { return }
                var list = vm.order.value
                guard list[index].number > 0 else { return }
                list[index].updateNumber(number: list[index].number - 1)
                vm.order.accept(list)
            }
            .disposed(by: disposeBag)
    }
    
    func getData() -> [OrderDishModel]? {
        guard !order.value.isEmpty else {
            return []
        }
        if let _ = order.value.first(where: {$0.name.isEmpty}) {
            error.accept(ErrorModel(message: "Please enter full dish"))
            return []
        }
        if let _ = order.value.first(where: {$0.number <= 0}) {
            error.accept(ErrorModel(message: "Please enter full number of serving"))
            return []
        }
        return order.value
    }
}

extension Reactive where Base: Inputs<MainStep3VM> {
    var previousTapped: AnyObserver<Void> {
        return base.vm.previousTapped.asObserver()
    }
    var nextTapped: AnyObserver<Void> {
        return base.vm.nextTapped.asObserver()
    }
    var dishTapped: AnyObserver<(UITapGestureRecognizer, Int)> {
        return base.vm.dishTapped.asObserver()
    }
    var numberOrderChange: AnyObserver<(Int, Int)> {
        return base.vm.numberOrderChange.asObserver()
    }
    var addTapped: AnyObserver<Void> {
        return base.vm.addTapped.asObserver()
    }
    var increaseTapped: AnyObserver<Int> {
        return base.vm.increaseTapped.asObserver()
    }
    var decreaseTapped: AnyObserver<Int> {
        return base.vm.decreaseTapped.asObserver()
    }
}

extension Reactive where Base: Outputs<MainStep3VM> {
    var order: BehaviorRelay<[OrderDishModel]> {
        return base.vm.order
    }
    var error: Signal<ErrorModel> {
        return base.vm.error.asSignal()
    }
}

extension MainStep3VM: PickerVCDelegate {
    func pickerVC(didSelected: String) {
        guard !order.value.isEmpty, editingIndex.value <= order.value.count else { return }
        var list = order.value
        list[editingIndex.value].updateName(name: didSelected)
        order.accept(list)
    }
}
