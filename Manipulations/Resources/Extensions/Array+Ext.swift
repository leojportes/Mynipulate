//
//  Array+Ext.swift
//  Manipulations
//
//  Created by Leonardo Portes on 29/12/22.
//

import UIKit

extension Array {
    func chunkedElements(into size: Int) -> [[Element]] {
        return stride(from: 0, to: count, by: size).map {
            Array(self[$0 ..< Swift.min($0 + size, count)])
        }
    }
}

public extension Array {
    static func += (lhs: inout Self, rhs: Self.Element) {
        lhs.append(rhs)
    }

    subscript(safeIndex indice: Int) -> Element? {
        indices.contains(index(indice, offsetBy: 0)) ? self[indice] : nil
    }

    func chunked(into size: Int) -> [[Element]] {
        stride(from: 0, to: count, by: size).map {
            Array(self[$0 ..< Swift.min($0 + size, count)])
        }
    }

    mutating func insertFirst(_ item: Element, limit: Int) {
        insert(item, at: 0)
        if count > limit { _ = removeLast() }
    }

    func doesNotContain(where predicate: (Element) throws -> Bool) rethrows -> Bool {
        try !contains(where: predicate)
    }

    func uniques<T: Hashable>(by keyPath: KeyPath<Element, T>) -> [Element] {
        var seen = Set<T>()
        return filter {
            seen.insert($0[keyPath: keyPath]).inserted
        }
    }

    func appending(_ newElement: Element) -> [Element] {
        var mutableSelf = self
        mutableSelf.append(newElement)
        return mutableSelf
    }

    /// A Boolean value indicating whether the collection is NOT empty.
    var isNotEmpty: Bool {
        !isEmpty
    }
}
