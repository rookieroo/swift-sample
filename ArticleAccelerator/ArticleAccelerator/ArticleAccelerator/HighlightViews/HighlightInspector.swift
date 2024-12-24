// See LICENSE folder for this sample’s licensing information.

import ArticleStore
import SwiftUI

struct HighlightInspector: View {
    let articleContent: AttributedString
    @Bindable var state: ArticleState

    var body: some View {
        ScrollViewReader { proxy in
            List(sortedHighlights) { highlight in
                HighlightView(highlight: highlight, content: NSAttributedString(articleContent)) {
                    delete(highlight)
                }
            }
            .onChange(of: sortedHighlights) { oldValue, newValue in
                if newValue.count > oldValue.count {
                    let oldSet = Set(oldValue)
                    let newSet = Set(newValue)
                    if let addedHighlight = newSet.subtracting(oldSet).first {
                        withAnimation {
                            proxy.scrollTo(addedHighlight.id, anchor: .top)
                        }
                    }
                }
            }
        }
    }
    
    @Environment(\.articleStateManager) private var stateManager
    @Environment(\.modelContext) private var modelContext
    
    private var sortedHighlights: [Highlight] {
        state.highlights.sorted { $0.range.lowerBound < $1.range.lowerBound }
    }
    
    private func delete(_ highlight: Highlight) {
        stateManager.removeHighlight(highlight)
    }
}
