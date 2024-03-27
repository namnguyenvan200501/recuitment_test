//
//  ViewModel+Output.swift
//  RecuitmentTest
//
//  Created by Nam Nguyễn on 27/03/2024.
//

import Foundation
import RxSwift

class Outputs<Base>: ReactiveCompatible {
    let vm: Base

    init(_ vm: Base) {
        self.vm = vm
    }
}

protocol OutputCompatible {
    associatedtype OutputCompatibleType

    var out: Outputs<OutputCompatibleType> { get }
}

extension ViewModel: OutputCompatible {
    typealias OutputCompatibleType = ViewModel
}

extension OutputCompatible {
    var out: Outputs<Self> { return Outputs(self) }
}
