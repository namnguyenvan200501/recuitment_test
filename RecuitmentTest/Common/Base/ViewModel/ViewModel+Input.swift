//
//  ViewModel+Input.swift
//  RecuitmentTest
//
//  Created by Nam Nguyễn on 27/03/2024.
//

import Foundation
import RxSwift

class Inputs<Base>: ReactiveCompatible {
    let vm: Base

    init(_ vm: Base) {
        self.vm = vm
    }

}

protocol InputCompatible {
    associatedtype InputCompatibleType: ViewModel

    var `in`: Inputs<InputCompatibleType> { get }
}

extension ViewModel: InputCompatible {
    typealias InputCompatibleType = ViewModel
}

extension InputCompatible where Self: ViewModel {
    var `in`: Inputs<Self> { return Inputs(self) }
}
