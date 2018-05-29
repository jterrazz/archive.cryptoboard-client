//
//  Array.swift
//  cryptoboard
//
//  Created by Jean Baptiste TERRAZZONI on 28/05/2018.
//  Copyright © 2018 terrazzoni. All rights reserved.
//

import Foundation

extension Array {
    mutating func rearrange(from: Int, to: Int) {
        precondition(from != to && indices.contains(from) && indices.contains(to), "invalid indexes")
        insert(remove(at: from), at: to)
    }
}
