// See LICENSE folder for this sample’s licensing information.

import ArticleStore
import SwiftData

@Model
final class ArticleState {
    @Attribute(.unique) let articleID: String
    var isBookmark: Bool
    var isComplete: Bool
    @Relationship(deleteRule: .cascade, inverse: \Highlight.articleState) var highlights = [Highlight]()

    init(articleID: String, isBookmark: Bool, isComplete: Bool) {
        self.articleID = articleID
        self.isBookmark = isBookmark
        self.isComplete = isComplete
    }
}
