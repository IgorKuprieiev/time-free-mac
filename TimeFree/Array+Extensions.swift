//
//  Array+Extensions.swift
//  TimeFree
//
//  Created by Oleksii Naboichenko on 5/29/16.
//  Copyright © 2016 Oleksii Naboichenko. All rights reserved.
//

import Foundation

extension Array {
    
    func randomItem() -> Element {
        let randomIndex = Int(arc4random_uniform(UInt32(count)))
        return self[randomIndex]
    }
}
