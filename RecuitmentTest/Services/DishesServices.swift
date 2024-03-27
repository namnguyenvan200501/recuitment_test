//
//  DishesServices.swift
//  RecuitmentTest
//
//  Created by Nam Nguyễn on 28/03/2024.
//

import Foundation
import RxSwift
import RxCocoa

protocol DishesService {
    var dishes: BehaviorRelay<[Dish]> { get }
}

class DishesServiceImpl: DishesService {
    var dishes: BehaviorRelay<[Dish]>
    init() {
        guard let path = Bundle.main.url(forResource: "dishes", withExtension: "json") else {
            dishes = .init(value: [])
            return
        }
        do {
            let data = try Data(contentsOf: path)
            let decoder = JSONDecoder()
            let jsonData = try decoder.decode(Dishes.self, from: data)
            dishes = .init(value: jsonData.dishes ?? [])
        } catch {
            dishes = .init(value: [])
        }
    }
}
