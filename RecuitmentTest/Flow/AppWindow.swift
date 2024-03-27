//
//  AppWindow.swift
//  RecuitmentTest
//
//  Created by Nam Nguyễn on 27/03/2024.
//

import UIKit
import RxSwift
import RxCocoa

class AppWindow: UIWindow {
    private (set) var mainNavi: MainNavigationController?
    
    private let disposeBag = DisposeBag()

    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = UIColor.black
        if #available(iOS 13.0, *) {
            overrideUserInterfaceStyle = .light
        }
        makeKeyAndVisible()
        rootViewController = createMainNaviIfNeed()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func runAnimate(options: UIView.AnimationOptions = .transitionCrossDissolve,
                            duration: TimeInterval = 0.3, animations: (() -> Void)? = nil) {
        UIView.transition(with: self, duration: duration, options: options, animations: animations)
    }
}

// MARK: - Create Flow
extension AppWindow {
    func createMainNaviIfNeed() -> MainNavigationController {
        if let navi = mainNavi {
            return navi
        } else {
            let navi = MainNavigationController()
            self.mainNavi = navi
            return navi
        }
    }
}

extension AppWindow {
}
