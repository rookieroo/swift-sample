// See LICENSE folder for this sample’s licensing information.

import ArticleStore
import Foundation
import SwiftData

extension [ArticleState] {
    func isComplete(for articleID: Article.ID) -> Bool {
        if let articleState = state(for: articleID), articleState.isComplete {
            return true
        }
        return false
    }
    
    func state(for identifier: Article.ID, createIn modelContext: ModelContext? = nil) -> ArticleState? {
        if let state = first(where: { $0.articleID == identifier }) {
            return state
        } else if let modelContext {
            let state = ArticleState(articleID: identifier, isBookmark: false, isComplete: false)
            modelContext.insert(state)
            return state
        } else {
            return nil
        }
    }
}
