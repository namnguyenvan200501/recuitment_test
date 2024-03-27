//
//  MainStepNavigationController.swift
//  RecuitmentTest
//
//  Created by Nam Nguyễn on 27/03/2024.
//

import UIKit
import RxSwift
import RxCocoa

class MainStepNavigationController: NavigationController {
    private (set) var mainStep1VC: MainStep1VC?
    private (set) var mainStep2VC: MainStep2VC?
    private (set) var mainStep3VC: MainStep3VC?
    private (set) var mainStep4VC: MainStep4VC?
    
    init(delegate: MainStep1Delegate?) {
        super.init()
        self.viewControllers = [createMainStep1VCIfNeed(delegate: delegate)]
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func pushTo(_ viewController: UIViewController) {
        let transition: CATransition = CATransition()
        transition.duration = 0.3
        transition.type = CATransitionType.push
        transition.subtype = CATransitionSubtype.fromRight
        view.layer.add(transition, forKey: nil)
        pushViewController(viewController, animated: false)
    }
}

extension MainStepNavigationController {
    func createMainStep1VCIfNeed(delegate: MainStep1Delegate?) -> MainStep1VC {
        if let vc = mainStep1VC {
            return vc
        } else {
            let vc = MainStep1VC(vm: MainStep1VM(delegate: delegate))
            self.mainStep1VC = vc
            return vc
        }
    }
    
    func createMainStep2VCIfNeed(delegate: MainStep2Delegate?, metal: Metal) -> MainStep2VC {
        if let vc = mainStep2VC {
            return vc
        } else {
            let vc = MainStep2VC(vm: MainStep2VM(delegate: delegate, metal: metal))
            self.mainStep2VC = vc
            return vc
        }
    }
    
    func createMainStep3VCIfNeed(delegate: MainStep3Delegate?, metal: Metal, restaurant: String) -> MainStep3VC {
        if let vc = mainStep3VC {
            return vc
        } else {
            let vc = MainStep3VC(vm: MainStep3VM(delegate: delegate, metal: metal, restaurant: restaurant))
            self.mainStep3VC = vc
            return vc
        }
    }
    
    func createMainStep4VCIfNeed(delegate: MainStep4Delegate?, data: MainStep4Data?) -> MainStep4VC {
        if let vc = mainStep4VC {
            return vc
        } else {
            let vc = MainStep4VC(vm: MainStep4VM(delegate: delegate, data: data))
            self.mainStep4VC = vc
            return vc
        }
    }
}

extension MainStepNavigationController {
    func endMainStep1VC(delegate: MainStep2Delegate?, metal: Metal = .none) {
        pushTo(createMainStep2VCIfNeed(delegate: delegate, metal: metal))
    }
    
    func endMainStep2VC(step: MainStep2Step, delegate: MainStep3Delegate? = nil, metal: Metal = .none, restaurant: String = "") {
        switch step {
        case .back:
            popViewController(animated: true)
            mainStep2VC = nil
        case .next:
            pushTo(createMainStep3VCIfNeed(delegate: delegate, metal: metal, restaurant: restaurant))
        }
    }
    
    func endMainStep3VC(step: MainStep3Step, delegate: MainStep4Delegate? = nil, data: MainStep4Data? = nil) {
        switch step {
        case .back:
            mainStep3VC = nil
            popViewController(animated: true)
        case .next:
            pushTo(createMainStep4VCIfNeed(delegate: delegate, data: data))
        }
    }
    
    func endMainStep4VC() {
        mainStep4VC = nil
        popViewController(animated: true)
    }
}
