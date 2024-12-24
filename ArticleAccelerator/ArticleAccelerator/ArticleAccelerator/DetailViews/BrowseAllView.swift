// See LICENSE folder for this sample’s licensing information.

import ArticleStore
import SwiftUI

struct BrowseAllView: View {
    let articles: [Article]
    
    var body: some View {
        VStack(alignment: .leading) {
            Button {
                withAnimation {
                    isShowingFilters.toggle()
                }
            } label: {
                Label("Filters", systemImage: isShowingFilters ? "chevron.up" : "chevron.down")
            }
            FiltersView(mediaFilter: $mediaFilter, sortFilter: $sortFilter)
                .pickerStyle(.inline)
                .frame(height: isShowingFilters ? pickerHeight : 0)
                .clipped()
            ArticleCollectionView(articles: sortedAndFilteredArticles)
                .padding(.top)
        }
    }
    
    @ScaledMetric(wrappedValue: 100, relativeTo: .body) private var pickerHeight: CGFloat
    @State private var isShowingFilters = false
    @State private var mediaFilter: FiltersView.MediaFilter = .any
    @State private var sortFilter: FiltersView.SortFilter = .alphaIncreasing
    
    private var filteredArticles: [Article] {
        articles.filter { mediaFilter.matches($0.media) }
    }
    private var sortedAndFilteredArticles: [Article] {
        switch sortFilter {
        case .recentlyAdded:
            return filteredArticles.sorted {
                guard let lhsDate = $0.date, let rhsDate = $1.date else {
                    return true
                }
                return lhsDate > rhsDate
            }
        case .alphaIncreasing:
            return filteredArticles.sorted {
                $0.hero.header.localizedCaseInsensitiveCompare($1.hero.header) == .orderedAscending
            }
        case .alphaDecreasing:
            return filteredArticles.sorted {
                $0.hero.header.localizedCaseInsensitiveCompare($1.hero.header) == .orderedDescending
            }
        }
    }
}

#Preview {
    BrowseAllView(articles: .samples)
        .environment(Presentation())
        .frame(width: 600, height: 500)
}
