//
//  MainVM.swift
//  RecuitmentTest
//
//  Created by Nam Nguyễn on 27/03/2024.
//

import Foundation
import RxSwift
import RxCocoa

enum MainStep {
    case step1
    case step2
    case step3
    case step4
}

class MainVM: ViewModel {
    fileprivate let stepNavi = BehaviorRelay<MainStepNavigationController?>(value: nil)
    
    fileprivate var currentStep = BehaviorRelay<MainStep>(value: .step1)
    
    fileprivate var dataStep1 = BehaviorRelay<(Metal, Int)>(value: (.none, 0))
    fileprivate var dataStep2 = BehaviorRelay<(String)>(value: "")
    
    override init() {
        super.init()
        stepNavi.accept(MainStepNavigationController(delegate: self))
        setupRx()
    }
    
    private func setupRx() {
    }
}

extension Reactive where Base: Inputs<MainVM> {
}

extension Reactive where Base: Outputs<MainVM> {
    var stepNavi: BehaviorRelay<MainStepNavigationController?> {
        return base.vm.stepNavi
    }
    var currentStep: BehaviorRelay<MainStep> {
        return base.vm.currentStep
    }
}

extension MainVM: MainStep1Delegate {
    func didTapButtonFromStep1() {
        guard let stepNavi = stepNavi.value else { return }
        guard let result = stepNavi.mainStep1VC?.vm.getData() else { return }
        stepNavi.endMainStep1VC(delegate: self, metal: result.0)
        dataStep1.accept(result)
        currentStep.accept(.step2)
    }
}

extension MainVM: MainStep2Delegate {
    func didTapButtonFromStep2(step: MainStep2Step) {
        guard let stepNavi = stepNavi.value else { return }
        switch step {
        case .back:
            stepNavi.endMainStep2VC(step: .back)
            currentStep.accept(.step1)
        case .next:
            guard let result = stepNavi.mainStep2VC?.vm.getData() else { return }
            stepNavi.endMainStep2VC(step: .next, delegate: self, metal: dataStep1.value.0, restaurant: result)
            dataStep2.accept(result)
            currentStep.accept(.step3)
        }
    }
}


extension MainVM: MainStep3Delegate {
    func didTapButtonFromStep3(step: MainStep3Step) {
        guard let stepNavi = stepNavi.value else { return }
        switch step {
        case .back:
            stepNavi.endMainStep3VC(step: .back)
            currentStep.accept(.step2)
        case .next:
            guard let result = stepNavi.mainStep3VC?.vm.getData(), !result.isEmpty else { return }
            let data = MainStep4Data(medal: dataStep1.value.0.stringValue,
                                     numOfPeople: dataStep1.value.1,
                                     restaurant: dataStep2.value,
                                     dishes: result)
            stepNavi.endMainStep3VC(step: .next, delegate: self, data: data)
            currentStep.accept(.step4)
        }
    }
}

extension MainVM: MainStep4Delegate {
    func didTapButtonFromStep4() {
        guard let stepNavi = stepNavi.value else { return }
        stepNavi.endMainStep4VC()
        currentStep.accept(.step3)
    }
}
