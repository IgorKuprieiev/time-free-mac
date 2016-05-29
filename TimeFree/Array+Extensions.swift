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
        let randomIndex = Int(rand()) % count
        return self[randomIndex]
    }
}