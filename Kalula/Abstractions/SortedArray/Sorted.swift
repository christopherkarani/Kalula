//
//  SortedArray.swift
//  Kalula
//
//  Created by Chris Karani on 06/10/2018.
//  Copyright © 2018 Christopher Brandon Karani. All rights reserved.
//

import Foundation

struct Sorted<Element: Comparable> {
    typealias Predicate = (Element, Element) -> Bool
    //  MARK: Properties
    private var elements : [Element]
    private let predicate : Predicate
}

extension Sorted {
    /// A convenience Initializer that allows the caller to describe the sorting predicate
    private init<S: Sequence>( unordered: S, predicate: @escaping Predicate) where S.Iterator.Element == Element {
        elements = unordered.sorted(by: predicate)
        self.predicate = predicate
    }
    
    /// A Convieniece Initilizer when Elements conform to the `Comparable` protocol
    /// in ascendingOrder
    internal init<S: Sequence>(_ s: S, predicate: @escaping Predicate ) where S.Iterator.Element == Element {
        self.init(unordered: s, predicate: <)
    }
}


extension Sorted: Collection {
    
    var startIndex: Int {
        return elements.startIndex
    }
    
    var endIndex: Int {
        return elements.endIndex
    }
    
    func index(after i: Int) -> Int {
        return elements.index(after: i)
    }
    
    subscript (position: Int) -> Element {
        return elements[position]
    }
}

extension Sorted : BidirectionalCollection {
    func index(before i: Int) -> Int {
        return elements.index(before: i)
    }
}

extension Sorted : ExpressibleByArrayLiteral {
    typealias ArrayLiteralElement = Element
    
    init(arrayLiteral elements: Element...) {
        self.elements = elements
        self.predicate =  { lhs, rhs in
            return lhs < rhs
        }
    }
}

extension Sorted: RangeReplaceableCollection  {
    init() {
        elements = []
        predicate = { lhs, rhs in
            lhs < rhs
        }
    }
    
    mutating func replaceSubrange<C, R>(_ subrange: R, with newElements: C) where C : Collection, R : RangeExpression, Element == C.Element, Int == R.Bound {
        elements.replaceSubrange(subrange, with: newElements)
    }
}
