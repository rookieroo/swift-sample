// See LICENSE folder for this sample’s licensing information.

import ArticleStore
import Foundation
import SwiftData
import SwiftUI

struct ArticleStateManager {
    let modelContext: ModelContext
    
    init(modelContext: ModelContext) {
        self.modelContext = modelContext
    }
    
    // MARK: - highlight functions
    func addHighlight(_ highlight: Highlight, to articleID: Article.ID) {
        let state = state(for: articleID, createIfMissing: true)
        state?.highlights.append(highlight)
    }
    
    func highlights(for articleID: Article.ID) -> [Highlight] {
        state(for: articleID)?.highlights ?? []
    }
    
    func removeHighlight(_ highlight: Highlight) {
        if let index = highlight.articleState?.highlights.firstIndex(where: { $0.id == highlight.id }) {
            highlight.articleState?.highlights.remove(at: index)
        }
        modelContext.delete(highlight)
    }
    
    // MARK: - toggle functions
    func markAsComplete(for articleID: Article.ID) {
        state(for: articleID, createIfMissing: true)?.isComplete = true
    }
    
    func toggleBookmark(for articleID: Article.ID) {
        state(for: articleID, createIfMissing: true)?.isBookmark.toggle()
    }
    
    // MARK: - state functions
    private func createState(for articleID: Article.ID) -> ArticleState {
        let state = ArticleState(articleID: articleID, isBookmark: false, isComplete: false)
        modelContext.insert(state)
        return state
    }
    
    private func state(for articleID: Article.ID, createIfMissing create: Bool = false) -> ArticleState? {
        let descriptor = FetchDescriptor<ArticleState>(
            predicate: #Predicate { $0.articleID == articleID }
        )
        let state = try? modelContext.fetch(descriptor).first
        if create {
            return state ?? createState(for: articleID)
        } else {
            return state
        }
    }
}

struct ArticleStateManagerKey: EnvironmentKey {
    static let defaultValue: ArticleStateManager = {
        let container = try! ModelContainer(for: ArticleState.self, TrainingPlanItem.self)
        let modelContext = ModelContext(container)
        return ArticleStateManager(modelContext: modelContext)
    }()
}

extension EnvironmentValues {
    var articleStateManager: ArticleStateManager {
        get { self[ArticleStateManagerKey.self] }
        set { self[ArticleStateManagerKey.self] = newValue }
    }
}
