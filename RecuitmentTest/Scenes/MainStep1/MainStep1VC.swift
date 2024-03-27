
import UIKit
import RxSwift
import RxCocoa
import RxGesture

class MainStep1VC: Controller<MainStep1VM> {
    
    @IBOutlet weak var viewMedal: UIView!
    @IBOutlet weak var btnNext: UIButton!
    @IBOutlet weak var tfNumberOfPeople: UITextField!
    @IBOutlet weak var lbMetal: UILabel!
    @IBOutlet weak var btnIncrease: UIButton!
    @IBOutlet weak var btnDecrease: UIButton!
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
        btnNext.rx.tap.bind(to: vm.in.rx.nextTapped).disposed(by: disposeBag)
        viewMedal.rx.tapGesture().when(.recognized).bind(to: vm.in.rx.metalTapped).disposed(by: disposeBag)
        btnIncrease.rx.tap.bind(to: vm.in.rx.increaseTapped).disposed(by: disposeBag)
        btnDecrease.rx.tap.bind(to: vm.in.rx.decreaseTapped).disposed(by: disposeBag)
        
        vm.out.rx.metalSelected
            .subscribe(with: self) { vc, metal in
                if let metal = metal {
                    vc.lbMetal.text = metal.stringValue
                } else {
                    vc.lbMetal.text = "---"
                }
            }
            .disposed(by: disposeBag)
        
        vm.out.rx.numOfPeople.subscribe(with: self) { vc, num in
            vc.tfNumberOfPeople.text = "\(num)"
        }
        .disposed(by: disposeBag)
        
        tfNumberOfPeople.rx.controlEvent(.editingChanged)
            .withLatestFrom(tfNumberOfPeople.rx.text)
            .map({ str in
                return Int(str ?? "") ?? 0
            })
            .bind(to: vm.in.rx.numOfPeople)
            .disposed(by: disposeBag)
        
        vm.out.rx.error.emit { err in
            showError(message: err.message ?? "")
        }
        .disposed(by: disposeBag)
    }
}
