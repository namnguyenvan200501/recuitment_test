//
//  Controller.swift
//  RecuitmentTest
//
//  Created by Nam Nguyễn on 27/03/2024.
//

import Foundation
import UIKit
import RxSwift

class Controller<VM: ViewModel>: UIViewController, UIViewControllerTransitioningDelegate, UINavigationControllerDelegate {
    var viewModel: VM!

    var vm: VM {
        return viewModel
    }

    let disposeBag = DisposeBag()

    override var prefersStatusBarHidden: Bool {
        return true
    }

    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }

    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .portrait
    }

    override var preferredInterfaceOrientationForPresentation: UIInterfaceOrientation {
        return .portrait
    }

    required init(vm: VM, nibName nibNameOrNil: String? = nil, bundle nibBundleOrNil: Bundle? = nil) {
        viewModel = vm
        let resourceName = nibNameOrNil ?? String(describing: Self.self)
        super.init(nibName: resourceName, bundle: nibBundleOrNil)
    }

    required init?(coder aDecoder: NSCoder) {
        self.viewModel = nil
        super.init(coder: aDecoder)
    }

    override func loadView() {
        super.loadView()
        rx.viewDidLoad
            .map { _ in .didLoad }
            .bind(to: vm.lifeCycle)
            .disposed(by: disposeBag)
    }

    override open func viewDidLoad() {
        super.viewDidLoad()
        setupLifeCycle()
        setup()
    }

    func setupLifeCycle() {
        rx.viewDidAppear
            .map { _ in .didAppear}
            .bind(to: vm.lifeCycle)
            .disposed(by: disposeBag)

        rx.viewWillAppear
            .map { _ in .willAppear}
            .bind(to: vm.lifeCycle)
            .disposed(by: disposeBag)

        rx.viewWillDisappear
            .map { _ in .willDisappear}
            .bind(to: vm.lifeCycle)
            .disposed(by: disposeBag)

        rx.viewDidDisappear
            .map { _ in .didDisappear}
            .bind(to: vm.lifeCycle)
            .disposed(by: disposeBag)
    }

    func setup() {
    }
}
