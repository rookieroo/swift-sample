// See LICENSE folder for this sample’s licensing information.

import Foundation

extension [Highlight] {
    func highlightsIntersectingRange(_ range: Range<Int>) -> Self {
        reduce([]) {
            var matches = $0
            if $1.range.overlaps(range) {
                matches.append($1)
            }
            return matches
        }
    }
}
