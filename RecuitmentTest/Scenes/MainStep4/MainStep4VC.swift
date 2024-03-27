
import UIKit
import RxSwift
import RxCocoa

class MainStep4VC: Controller<MainStep4VM> {
    
    @IBOutlet weak var viewContent: UIView!
    
    @IBOutlet weak var lbMedal: UILabel!
    @IBOutlet weak var lbNumOfPeople: UILabel!
    @IBOutlet weak var lbRestaurent: UILabel!
    @IBOutlet weak var stackViewDishes: UIStackView!
    
    @IBOutlet weak var btnPrevious: UIButton!
    @IBOutlet weak var btnSubmit: UIButton!
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
        vm.out.rx.data
            .compactMap({$0})
            .subscribe(with: self) { vc, data in
                vc.lbMedal.text = data.medal
                vc.lbNumOfPeople.text = "\(data.numOfPeople)"
                vc.lbRestaurent.text = data.restaurant
                vc.setForDishes(data.dishes)
            }
            .disposed(by: disposeBag)
    }
    
    func setForDishes(_ list: [OrderDishModel]) {
        stackViewDishes.arrangedSubviews.forEach({$0.removeFromSuperview()})
        for item in list {
            var viewItem = MainStep4OrderItemCustomView()
            viewItem.dataConfigs.accept(item)
            stackViewDishes.addArrangedSubview(viewItem)
        }
    }
}
