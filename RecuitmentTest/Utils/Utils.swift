//
//  Utils.swift
//  RecuitmentTest
//
//  Created by Nam Nguyễn on 28/03/2024.
//

import Foundation
import UIKit

func showPicker(delegate: PickerVCDelegate?, current: String, list: [(value: String, enable: Bool)]) {
    let dateVC = PickerViewController(delegate: delegate, current: current, list: list)
    dateVC.modalPresentationStyle = .overFullScreen
    dateVC.modalTransitionStyle = .crossDissolve
    appWindow?.rootViewController?.present(dateVC, animated: true)
}

func showError(message: String) {
    let alert = UIAlertController(title: nil, message: message, preferredStyle: .alert)
    alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
    appWindow?.rootViewController?.present(alert, animated: true)
}
