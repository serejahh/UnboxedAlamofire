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

extension Candy {
    
    init(unboxer: Unboxer) throws {
        self.name = try unboxer.unbox(key: "name")
        self.sweetnessLevel = try unboxer.unbox(key: "sweetness_level")
    }
}
