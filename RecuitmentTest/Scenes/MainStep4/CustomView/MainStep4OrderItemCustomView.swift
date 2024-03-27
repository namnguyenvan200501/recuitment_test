//
//  MainStep4OrderItemCustomView.swift
//  RecuitmentTest
//
//  Created by Nam Nguyễn on 28/03/2024.
//

import UIKit
import RxCocoa
import RxSwift

class MainStep4OrderItemCustomView: CustomView {
    
    @IBOutlet weak var lbName: UILabel!
    @IBOutlet weak var lbNum: UILabel!
    var dataConfigs = BehaviorRelay<OrderDishModel>(value: OrderDishModel())
    let disposeBag = DisposeBag()
    override func setup() {
        super.setup()
        setupRx()
    }
    private func setupRx() {
        dataConfigs
            .map({ $0.name })
            .bind(to: lbName.rx.text)
            .disposed(by: disposeBag)
        dataConfigs
            .map{( "- \($0.number)" )}
            .bind(to: lbNum.rx.text)
            .disposed(by: disposeBag)
    }
}
