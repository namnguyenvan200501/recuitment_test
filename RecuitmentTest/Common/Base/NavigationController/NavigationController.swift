//
//  NavigationController.swift
//  RecuitmentTest
//
//  Created by Nam Nguyễn on 27/03/2024.
//

import UIKit

class NavigationController: UINavigationController {

    var tag: Int = 0

    init() {
        super.init(nibName: nil, bundle: nil)
        isNavigationBarHidden = true
        modalPresentationStyle = .overFullScreen
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func pushNavi(navi: NavigationController, animated: Bool) {
        if animated {
            view.window?.layer.add(CATransition().pushFromBottom(), forKey: kCATransition)
        }
        present(navi, animated: false)
    }

    func dismissNavi(animated: Bool) {
        if animated {
            view.window?.layer.add(CATransition().popFromTop(), forKey: kCATransition)
        }
        dismiss(animated: false)
    }
}
