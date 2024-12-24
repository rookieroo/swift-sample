// See LICENSE folder for this sample’s licensing information.

import ArticleStore
import SwiftUI

struct ArticleContextMenu: ViewModifier {
    let articleID: Article.ID
    
    func body(content: Content) -> some View {
        content
            .contextMenu {
                Button("Open in New Window") {
                    openWindow(value: articleID)
                }
            }
    }

    @Environment(\.openWindow) private var openWindow
}

extension View {
    func contextMenu(for articleID: Article.ID) -> some View {
        modifier(ArticleContextMenu(articleID: articleID))
    }
}
