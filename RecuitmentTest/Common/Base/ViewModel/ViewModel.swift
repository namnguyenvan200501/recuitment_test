//
//  ViewModel.swift
//  RecuitmentTest
//
//  Created by Nam Nguyễn on 27/03/2024.
//

import Foundation
import RxSwift
import RxCocoa

enum LifeCycle {
    case didAppear
    case willAppear
    case didLoad
    case willDisappear
    case didDisappear
}

class ViewModel {
    private(set) var disposeBag = DisposeBag()

    let lifeCycle = PublishRelay<LifeCycle>()

    init() {

    }
}
