//
//  Candy.swift
//  UnboxedAlamofire
//
//  Created by Serhii Butenko on 1/8/16.
//  Copyright © 2016 Serhii Butenko. All rights reserved.
//

import Unbox

struct Candy {
    let name: String
    let sweetnessLevel: Int
}

extension Candy: Unboxable {
    init(unboxer: Unboxer) {
        self.name = unboxer.unbox("name")
        self.sweetnessLevel = unboxer.unbox("sweetness_level")
    }
}