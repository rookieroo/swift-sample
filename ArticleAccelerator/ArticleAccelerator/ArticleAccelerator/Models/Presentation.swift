// See LICENSE folder for this sample’s licensing information.

import ArticleStore
import Foundation
import Observation

@Observable
final class Presentation {
    var layoutStyle: CollectionLayoutStyle
    
    init(layoutStyle: CollectionLayoutStyle = .grid) {
        self.layoutStyle = layoutStyle
    }
}
