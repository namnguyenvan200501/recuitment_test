//
//  MainVC.swift
//  RecuitmentTest
//
//  Created by Nam Nguyễn on 27/03/2024.
//

import UIKit
import RxSwift
import RxCocoa

class MainVC: Controller<MainVM> {

    @IBOutlet weak var viewStep1: UIView!
    @IBOutlet weak var lbStep1: UILabel!
    
    @IBOutlet weak var viewStep2: UIView!
    @IBOutlet weak var lbStep2: UILabel!
    
    @IBOutlet weak var viewStep3: UIView!
    @IBOutlet weak var lbStep3: UILabel!
    
    @IBOutlet weak var viewStep4: UIView!
    @IBOutlet weak var lbStep4: UILabel!
    
    @IBOutlet weak var scrollViewStep: UIScrollView!
    @IBOutlet weak var stackViewStep: UIStackView!
    override func setup() {
        setupView()
        setupRx()
    }

    private func setupView() {
        print("init")
    }
    
    private func setupRx() {
        vm.out.rx.stepNavi.compactMap({$0}).subscribe(with: self) { vc, navi in
            vc.configureStepNavi(navi: navi)
        }
        .disposed(by: disposeBag)
        
        vm.out.rx.currentStep.subscribe(with: self) { vc, step in
            switch step {
            case .step1:
                vc.setupUI(step: 1)
            case .step2:
                vc.setupUI(step: 2)
            case .step3:
                vc.setupUI(step: 3)
            case .step4:
                vc.setupUI(step: 4)
            }
        }
        .disposed(by: disposeBag)
    }
    
    func configureStepNavi(navi: MainStepNavigationController) {
        addChild(navi)
        stackViewStep.addArrangedSubview(navi.view)
        navi.view.translatesAutoresizingMaskIntoConstraints = false
        navi.view.widthAnchor.constraint(equalTo: scrollViewStep.widthAnchor).isActive = true
    }
    
    func setupUI(step: Int) {
        viewStep1.backgroundColor = step == 1 ? .systemBlue : .clear
        viewStep1.layer.borderWidth = step == 1 ? 0 : 1
        lbStep1.textColor = step == 1 ? .white : .black
        
        viewStep2.backgroundColor = step == 2 ? .systemBlue : .clear
        viewStep2.layer.borderWidth = step == 2 ? 0 : 1
        lbStep2.textColor = step == 2 ? .white : .black
        
        viewStep3.backgroundColor = step == 3 ? .systemBlue : .clear
        viewStep3.layer.borderWidth = step == 3 ? 0 : 1
        lbStep3.textColor = step == 3 ? .white : .black
        
        viewStep4.backgroundColor = step == 4 ? .systemBlue : .clear
        viewStep4.layer.borderWidth = step == 4 ? 0 : 1
        lbStep4.textColor = step == 4 ? .white : .black
    }
}
