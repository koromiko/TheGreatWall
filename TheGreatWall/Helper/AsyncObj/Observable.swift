//
//  Observable.swift
//  TheGreatWall
//
//  Created by Neo on 19/06/2018.
//  Copyright © 2018 STH. All rights reserved.
//

import Foundation

class Observable<T> {
    var value: T {
        didSet {
            DispatchQueue.main.async {
                self.valueChanged?(self.value)
            }
        }
    }

    var valueChanged: ((T) -> Void)?

    init(value: T) {
        self.value = value
    }
}
