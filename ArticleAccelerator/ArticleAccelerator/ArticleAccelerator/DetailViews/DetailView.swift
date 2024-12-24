// See LICENSE folder for this sample’s licensing information.

import ArticleStore
import SwiftData
import SwiftUI

struct DetailView: View {
    @Binding var sidebarSelection: SidebarSelection
    
    var body: some View {
        Group {
            if isSearching && (numberOfMatches < 1) {
                ContentUnavailableView.search
            } else {
                if isSearching {
                    searchResultsLabel()
                }
                switch sidebarSelection {
                case .featured:
                    FeaturedView(featured: ArticleStore.shared.featuredArticles(), comingSoon: ArticleStore.shared.comingSoonArticles())
                        .environment(Presentation(layoutStyle: .grid))
                case .myStuff:
                    MyStuffView(bookmarked: matchingBookmarkedArticles, completed: matchingCompletedArticles)
                        .padding(design.padding)
                        .gesture(
                            LongPressGesture(minimumDuration: 3.0)
                                .onEnded { _ in
                                    isShowingDeletionDialog = true
                                }
                        )
                case .recentlyAdded:
                    RecentlyAddedView(articles: matchingArticles)
                        .padding(design.padding)
                case .browseAll:
                    BrowseAllView(articles: matchingArticles)
                        .padding(design.padding)
                }
            }
        }
        .confirmationDialog("Warning, this deletes all your bookmarks and progress.", isPresented: $isShowingDeletionDialog) {
            Button("Delete all user data?", role: .destructive) {
                do {
                    try context.delete(model: ArticleState.self)
                } catch {
                    fatalError("Error deleting user data. Application has stopped.")
                }
            }
        } message: {
            Text("You can't undo this action.")
        }
        .dialogIcon(
            Image(systemName: "bookmark.slash.fill")
        )
        .toolbar {
            if searchCondition {
                ToolbarItem(placement: .primaryAction) {
                    SearchField(search: $search)
                }
            }
        }
    }
    
    @Environment(\.modelContext) private var context
    @Query private var articleStates: [ArticleState]
    @State private var isShowingDeletionDialog = false
    @State private var search: String = ""
    
    private let articles = ArticleStore.shared.articles()
    private var isSearching: Bool { !search.isEmpty && (sidebarSelection != .featured) }
    private var searchCondition: Bool { sidebarSelection != .featured }
    private var matchingArticles: [Article] {
        articles.matchingSearchResults(search)
    }
    private var matchingBookmarkedArticles: [Article] {
        matchingArticles.bookmarked(in: articleStates)
    }
    private var matchingCompletedArticles: [Article] {
        matchingArticles.completed(in: articleStates)
    }
    private var numberOfMatches: Int {
        switch sidebarSelection {
        case .featured:
            0
        case .myStuff:
            matchingBookmarkedArticles.count + matchingCompletedArticles.count
        default:
            matchingArticles.count
        }
    }
    
    private func searchResultsLabel() -> some View {
        let singularMessage = "Showing 1 result."
        let pluralFormat = "Showing %d results."
        let message = numberOfMatches > 1 ? String(format: pluralFormat, numberOfMatches) : singularMessage
        return Text(message)
            .padding()
    }
}

#Preview {
    ScrollView {
        DetailView(sidebarSelection: .constant(.browseAll))
            .environment(Presentation(layoutStyle: .list))
    }
    .frame(width: 600, height: 800)
}

fileprivate typealias design = Design.Detail
