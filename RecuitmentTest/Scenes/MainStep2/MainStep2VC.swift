
import UIKit
import RxSwift
import RxCocoa
import RxGesture

class MainStep2VC: Controller<MainStep2VM> {
    
    @IBOutlet weak var lbRestaurant: UILabel!
    @IBOutlet weak var btnPrevious: UIButton!
    @IBOutlet weak var btnNext: UIButton!
    
    @IBOutlet weak var viewRestaurant: UIView!
    override func setup() {
        setupView()
        setupTexts()
        setupRx()
    }
    
    private func setupView() {
    }
    
    private func setupTexts() {
    }
    
    private func setupRx() {
        btnPrevious.rx.tap.bind(to: vm.in.rx.previousTapped).disposed(by: disposeBag)
        btnNext.rx.tap.bind(to: vm.in.rx.nextTapped).disposed(by: disposeBag)
        viewRestaurant.rx.tapGesture().when(.recognized).bind(to: vm.in.rx.restaurantTapped).disposed(by: disposeBag)
        
        vm.out.rx.restaurantSelected
            .subscribe(with: self) { vc, data in
                vc.lbRestaurant.text = data
            }
            .disposed(by: disposeBag)
        vm.out.rx.error.emit { err in
            showError(message: err.message ?? "")
        }
        .disposed(by: disposeBag)
    }
}
