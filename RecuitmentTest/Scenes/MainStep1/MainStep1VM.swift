
import Foundation
import RxSwift
import RxCocoa

protocol MainStep1Delegate: AnyObject {
    func didTapButtonFromStep1()
}

enum Metal: CaseIterable {
    case none
    case breakfast
    case lunch
    case dinner
    
    init?(_ value: String) {
        switch value {
        case "Breakfast":
            self = .breakfast
        case "Lunch":
            self = .lunch
        case "Dinner":
            self = .dinner
        default:
            return nil
        }
    }
    
    var stringValue: String {
        switch self {
        case .breakfast:
            return "Breakfast"
        case .lunch:
            return "Lunch"
        case .dinner:
            return "Dinner"
        case .none:
            return "---"
        }
    }
}

class MainStep1VM: ViewModel {
    
    var delegate: MainStep1Delegate?
    
    fileprivate let nextTapped = PublishRelay<Void>()
    fileprivate let metalTapped = PublishRelay<UITapGestureRecognizer>()
    
    fileprivate let increaseTapped = PublishRelay<Void>()
    fileprivate let decreaseTapped = PublishRelay<Void>()
    
    fileprivate let metalSelected = BehaviorRelay<Metal?>(value: nil)
    fileprivate let metalList = BehaviorRelay<[Metal]>(value: [.breakfast, .dinner, .lunch])
    fileprivate let numOfPeople = BehaviorRelay<Int>(value: 1)
    
    fileprivate let error = PublishRelay<ErrorModel>()
    
    init(delegate: MainStep1Delegate?) {
        self.delegate = delegate
        super.init()
        setupRx()
    }
    
    private func setupRx() {
        nextTapped
            .subscribe(with: self) { vm, _ in
                vm.delegate?.didTapButtonFromStep1()
            }
            .disposed(by: disposeBag)
        
        metalTapped
            .subscribe(with: self) { vm, _ in
                var metals: [(value: String, enable: Bool)] {
                    Metal.allCases.map {
                        ($0.stringValue, true)
                    }
                }
                showPicker(delegate: vm, current: vm.metalSelected.value?.stringValue ?? "", list: metals)
            }
            .disposed(by: disposeBag)
        
        increaseTapped
            .subscribe(with: self) { vm, _ in
                vm.numOfPeople.accept(vm.numOfPeople.value + 1)
            }
            .disposed(by: disposeBag)
        
        decreaseTapped
            .subscribe(with: self) { vm, _ in
                guard vm.numOfPeople.value > 0 else { return }
                vm.numOfPeople.accept(vm.numOfPeople.value - 1)
            }
            .disposed(by: disposeBag)
    }
    
    func getData() -> (Metal, Int)? {
        guard let metal = metalSelected.value else {
            error.accept(ErrorModel(message: "Please select metal"))
            return nil
        }
        guard numOfPeople.value > 0 else {
            error.accept(ErrorModel(message: "Please enter number of people"))
            return nil
        }
        return (metal, numOfPeople.value)
    }
}

extension Reactive where Base: Inputs<MainStep1VM> {
    var nextTapped: AnyObserver<Void> {
        return base.vm.nextTapped.asObserver()
    }
    var metalTapped: AnyObserver<UITapGestureRecognizer> {
        return base.vm.metalTapped.asObserver()
    }
    var increaseTapped: AnyObserver<Void> {
        return base.vm.increaseTapped.asObserver()
    }
    var decreaseTapped: AnyObserver<Void> {
        return base.vm.decreaseTapped.asObserver()
    }
    var numOfPeople: AnyObserver<Int> {
        return base.vm.numOfPeople.asObserver()
    }
}

extension Reactive where Base: Outputs<MainStep1VM> {
    var numOfPeople: BehaviorRelay<Int> {
        return base.vm.numOfPeople
    }
    var metalSelected: BehaviorRelay<Metal?> {
        return base.vm.metalSelected
    }
    var error: Signal<ErrorModel> {
        return base.vm.error.asSignal()
    }
}

extension MainStep1VM: PickerVCDelegate {
    func pickerVC(didSelected: String) {
        guard let metal = Metal(didSelected) else { return }
        metalSelected.accept(metal)
    }
}
