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
    
    init(name: String, sweetnessLevel: Int) {
        self.name = name
        self.sweetnessLevel = sweetnessLevel
    }
}

extension Candy: Unboxable {
    
    init(unboxer u: Unboxer) {
        self.init(name: u.unbox("name"), sweetnessLevel: u.unbox("sweetness_level"))
    }
}