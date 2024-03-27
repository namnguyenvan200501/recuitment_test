//
//  Container.swift
//  RecuitmentTest
//
//  Created by Nam Nguyễn on 28/03/2024.
//

import Foundation
import Swinject

class DIManager {
    static var container: Container = {
        let container = Container()
        
        container
            .register(DishesService.self, factory: { _ in
                return DishesServiceImpl()
            })
            .inObjectScope(.container)
        return container
    }()
}

extension DIManager {
    static func send<T>(_ value: T, withKey key: String) {
        container.register(T.self, name: key) { _ -> T in
            return value
        }
    }

    static func get<T>(key: String? = nil) -> T {
        guard let t = container.resolve(T.self, name: key) else {
            fatalError("Could not resolve dependency for key: \(key ?? "unknown")")
        }
        return t
    }

    static func get<T, P>(arg: P, key: String? = nil) -> T {
        guard let t = container.resolve(T.self, name: key, argument: arg) else {
            fatalError("Could not resolve dependency for key: \(key ?? "unknown")")
        }
        return t
    }
}
