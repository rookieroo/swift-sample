// See LICENSE folder for this sample’s licensing information.

import ArticleStore
import SwiftUI

struct FocusedArticleKey: FocusedValueKey {
    typealias Value = Article
}

extension FocusedValues {
    var article: FocusedArticleKey.Value? {
        get { self[FocusedArticleKey.self] }
        set { self[FocusedArticleKey.self] = newValue }
    }
}
