
import UIKit
import RxSwift
import RxCocoa
import RxGesture

class MainStep3VC: Controller<MainStep3VM> {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var heightOfTableView: NSLayoutConstraint!
    
    @IBOutlet weak var btnAdd: UIButton!
    
    @IBOutlet weak var btnPrevious: UIButton!
    @IBOutlet weak var btnNext: UIButton!
    override func setup() {
        setupView()
        setupTexts()
        setupRx()
    }
    
    private func setupView() {
        tableView.register(UINib(nibName: "MainStep3ItemCell", bundle: nil), forCellReuseIdentifier: "MainStep3ItemCell")
    }
    
    private func setupTexts() {
    }
    
    private func setupRx() {
        btnPrevious.rx.tap.bind(to: vm.in.rx.previousTapped).disposed(by: disposeBag)
        btnNext.rx.tap.bind(to: vm.in.rx.nextTapped).disposed(by: disposeBag)
        btnAdd.rx.tap.bind(to: vm.in.rx.addTapped).disposed(by: disposeBag)
        
        vm.out.rx.order
            .do {[weak self] values in
                self?.heightOfTableView.constant = CGFloat(values.count * 186)
            }
            .bind(to: tableView.rx.items(cellIdentifier: "MainStep3ItemCell",
                                         cellType: MainStep3ItemCell.self)) {[weak self] index, model, cell in
                guard let this = self else { return }
                cell.setupData(data: model)
                cell.rx.dishTapped.when(.recognized)
                    .map { gesture in
                        return (gesture, index)
                    }
                    .bind(to: this.vm.in.rx.dishTapped)
                    .disposed(by: cell.disposeBag)
                cell.rx.numberChange
                    .withLatestFrom(cell.tfNumOfDish.rx.text)
                    .map({ str in
                        return (Int(str ?? "") ?? 0, index)
                    })
                    .bind(to: this.vm.in.rx.numberOrderChange)
                    .disposed(by: cell.disposeBag)
                cell.rx.increaseTapped
                    .map({ index })
                    .bind(to: this.vm.in.rx.increaseTapped)
                    .disposed(by: cell.disposeBag)
                cell.rx.decreaseTapped
                    .map({ index })
                    .bind(to: this.vm.in.rx.decreaseTapped)
                    .disposed(by: cell.disposeBag)
            }
            .disposed(by: disposeBag)
        
        vm.out.rx.error.emit { err in
            showError(message: err.message ?? "")
        }
        .disposed(by: disposeBag)
    }
}
