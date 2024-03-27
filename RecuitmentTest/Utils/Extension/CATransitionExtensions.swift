//
//  CATransitionExtensions.swift
//  RecuitmentTest
//
//  Created by Nam Nguyễn on 27/03/2024.
//

import UIKit

extension CATransition {
    func pushFromBottom() -> CATransition {
        duration = 0.4
        timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
        type = CATransitionType.moveIn
        subtype = CATransitionSubtype.fromTop
        return self
    }
    
    func popFromTop() -> CATransition {
        duration = 0.5
        timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
        type = CATransitionType.reveal
        subtype = CATransitionSubtype.fromBottom
        return self
    }
}
