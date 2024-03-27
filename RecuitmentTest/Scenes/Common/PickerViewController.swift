//
//  PickerViewController.swift
//  RecuitmentTest
//
//  Created by Nam Nguyễn on 28/03/2024.
//

import UIKit
import RxSwift
import RxCocoa
import RxGesture

protocol PickerVCDelegate: AnyObject {
    func pickerVC(didSelected: String)
}

class PickerViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate {

    let disposeBag = DisposeBag()
    
    @IBOutlet weak var viewBg: UIView!
    @IBOutlet weak var btnCancel: UIButton!
    @IBOutlet weak var btnDone: UIButton!
    @IBOutlet weak var pickerView: UIPickerView!
    
    @IBOutlet weak var viewContent: UIView!
    @IBOutlet weak var bottomConstraint: NSLayoutConstraint!
    weak var delegate: PickerVCDelegate?
    var arrayValue: [(value: String, enable: Bool)] = []
    var currentItemPick = ""
    
    required init(delegate: PickerVCDelegate?, current: String, list: [(value: String, enable: Bool)]) {
        self.delegate = delegate
        self.currentItemPick = current
        self.arrayValue = list
        super.init(nibName: String(describing: Self.self), bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bottomConstraint.constant = -viewContent.frame.height
        pickerView.delegate = self
        if let index = arrayValue.firstIndex(where: { (value, _) in
            value.elementsEqual(self.currentItemPick)
        }) {
            pickerView.selectRow(index, inComponent: 0, animated: true)
        }
        setupRx()
    }
    
    func setupRx() {
        btnCancel.rx.tap
            .subscribe(with: self) { vc, _ in
                vc.dismissWithAnimate()
            }
            .disposed(by: disposeBag)
        viewBg.rx.tapGesture().when(.recognized)
            .subscribe(with: self) { vc, _ in
                vc.dismissWithAnimate()
            }
            .disposed(by: disposeBag)
        btnDone.rx.tap
            .subscribe(with: self) { vc, _ in
                vc.delegate?.pickerVC(didSelected: vc.currentItemPick)
                vc.dismissWithAnimate()
            }
            .disposed(by: disposeBag)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        if view.tag == 0 {
            view.tag = 1
            UIView.animate(withDuration: 0.3) {
                self.bottomConstraint.constant = 0
                self.view.layoutIfNeeded()
            }
        }
    }
    
    private func dismissWithAnimate() {
        bottomConstraint.constant = -viewContent.frame.height
        UIView.animate(withDuration: 0.3, animations: {
            self.view.layoutIfNeeded()
        })
        dismiss(animated: true)
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return arrayValue.count
    }
    
    // return item pick in array
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        let item = arrayValue[row]
        guard item.enable else {
            if let lastIndex = arrayValue.lastIndex(where: {
                $0.enable
            }) {
                pickerView.selectRow(lastIndex, inComponent: component, animated: true)
                currentItemPick = arrayValue[lastIndex].value
                return
            }
            currentItemPick = ""
            return
        }
        currentItemPick = item.value
    }
    
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        let labelString = UILabel(frame: CGRect(x: 0, y: 0, width: pickerView.frame.width, height: 50))
        let val = arrayValue[row]
        labelString.textColor = val.enable ? .black : .black.withAlphaComponent(0.5)
        labelString.font = .systemFont(ofSize: 16)
        labelString.text = val.value
        labelString.textAlignment = .center
        return labelString
        
    }
    
    func pickerView(_ pickerView: UIPickerView, widthForComponent component: Int) -> CGFloat {
        return pickerView.frame.width
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return arrayValue[row].value
    }
}
