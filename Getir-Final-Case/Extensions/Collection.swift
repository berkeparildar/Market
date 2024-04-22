//
//  Collection.swift
//  Getir-Final-Case
//
//  Created by Berke Parıldar on 10.04.2024.
//

import Foundation

extension Collection where Indices.Iterator.Element == Index {
    subscript(safe index: Index) -> Iterator.Element? {
        return indices.contains(index) ? self[index] : nil
    }
}
