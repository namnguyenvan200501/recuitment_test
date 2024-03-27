//
//  PublishRelay+Rx.swift
//  RecuitmentTest
//
//  Created by Nam Nguyễn on 27/03/2024.
//

import Foundation
import RxSwift
import RxCocoa

extension PublishRelay {
    func asObserver() -> AnyObserver<Element> {
        return .init { [weak self] (event) in
            guard let element = event.element else { return }
            self?.accept(element)
        }
    }
}
