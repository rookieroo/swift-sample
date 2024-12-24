// See LICENSE folder for this sample’s licensing information.

import ArticleStore
import SwiftData
import SwiftUI

struct ArticleCollectionView: View {
    let articles: [Article]
    
    var body: some View {
        Group {
            switch presentation.layoutStyle {
            case .grid:
                LazyVGrid(columns: columns, alignment: .leading, spacing: design.Grid.verticalSpacing) {
                    items(from: articles)
                }
            case .list:
                VStack(alignment: .leading, spacing: design.List.verticalSpacing) {
                    items(from: articles)
                }
            }
        }
        .animation(.easeInOut, value: articles)
    }
    
    @Environment(\.openWindow) private var openWindow
    @Environment(Presentation.self) private var presentation
    @Query private var articleStates: [ArticleState]
    
    private var columns: [GridItem] {
        [GridItem(.adaptive(minimum: design.Grid.width), spacing: design.Grid.horizontalSpacing, alignment: .topLeading)]
    }
    
    private func items(from articles: [Article]) -> some View {
        ForEach(articles) { article in
            NavigationLink(value: article.id) {
                ArticleCollectionItem(article: article, isComplete: articleStates.isComplete(for: article.id))
                    .draggable(article.id)
                    .contextMenu(for: article.id)
            }
        }
    }
}

#Preview {
    ArticleCollectionView(articles: .samples)
        .environment(Presentation())
        .frame(width: 600, height: 500)
}

fileprivate typealias design = Design.Detail
