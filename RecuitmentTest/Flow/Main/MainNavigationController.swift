//
//  MainNavigationController.swift
//  RecuitmentTest
//
//  Created by Nam Nguyễn on 27/03/2024.
//

import UIKit
import RxSwift
import RxCocoa

class MainNavigationController: NavigationController {
    private (set) var mainVC: MainVC?

    override init() {
        super.init()
        viewControllers = [createMainVCIfNeed()]
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension MainNavigationController {
    func createMainVCIfNeed() -> MainVC {
        if let vc = mainVC {
            return vc
        } else {
            let vc = MainVC(vm: MainVM())
            self.mainVC = vc
            return vc
        }
    }
}

extension MainNavigationController {
}
