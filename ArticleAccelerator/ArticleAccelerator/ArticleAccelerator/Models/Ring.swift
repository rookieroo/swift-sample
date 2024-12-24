// See LICENSE folder for this sample’s licensing information.

import Foundation

struct Ring<S: Equatable> {
    var count: Int { items.count }
    var isEmpty: Bool { items.isEmpty }
    
    private var items: [S]
    
    init(_ items: [S]) {
        self.items = items
    }
    
    func item(before item: S) -> S? {
        guard let position = items.firstIndex(of: item) else { return nil }
        var previousPosition = items.index(before: position)
        if previousPosition >= items.startIndex { return items[previousPosition] }
        previousPosition = items.endIndex - 1
        if previousPosition > position { return items[previousPosition] }
        return nil
    }
    
    func item(after item: S) -> S? {
        guard let position = items.firstIndex(of: item) else { return nil }
        var nextPosition = items.index(after: position)
        if nextPosition < items.endIndex { return items[nextPosition] }
        nextPosition = items.startIndex
        if nextPosition < position { return items[nextPosition] }
        return nil
    }
    
    subscript(index: Int) -> S {
        get {
            items[index]
        } set {
            items[index] = newValue
        }
    }
}
