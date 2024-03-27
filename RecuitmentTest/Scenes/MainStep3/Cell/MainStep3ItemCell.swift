//
//  MainStep3ItemCell.swift
//  RecuitmentTest
//
//  Created by Nam Nguyễn on 27/03/2024.
//

import UIKit
import RxSwift
import RxCocoa
import RxGesture

class MainStep3ItemCell: UITableViewCell {

    var disposeBag = DisposeBag()
    
    @IBOutlet weak var viewDish: UIView!
    @IBOutlet weak var lbDish: UILabel!
    @IBOutlet weak var tfNumOfDish: UITextField!
    
    @IBOutlet weak var btnIncrease: UIButton!
    @IBOutlet weak var btnDecrease: UIButton!
    
    override func prepareForReuse() {
        super.prepareForReuse()
        disposeBag = DisposeBag()
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        selectionStyle = .none
    }
    
    func setupData(data: OrderDishModel) {
        lbDish.text = data.name
        tfNumOfDish.text = "\(data.number)"
    }
}

extension Reactive where Base: MainStep3ItemCell {
    var dishTapped: ControlEvent<UITapGestureRecognizer> {
        return base.viewDish.rx.tapGesture()
    }
    
    var numberChange: ControlEvent<Void> {
        return base.tfNumOfDish.rx.controlEvent(.editingChanged)
    }
    
    var increaseTapped: ControlEvent<Void> {
        return base.btnIncrease.rx.tap
    }
    
    var decreaseTapped: ControlEvent<Void> {
        return base.btnDecrease.rx.tap
    }
}
