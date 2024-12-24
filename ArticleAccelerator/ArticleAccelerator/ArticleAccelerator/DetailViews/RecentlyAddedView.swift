// See LICENSE folder for this sample’s licensing information.

import ArticleStore
import SwiftUI

struct RecentlyAddedView: View {
    let articles: [Article]
    
    var body: some View {
        let dates = articles.compactMap { $0.date }
        let hasContent = dates.reduce(false) { $0 || $1 > Period.year.dateRange.lowerBound }
        
        if !hasContent {
            ContentUnavailableView {
                Label("No recent articles", systemImage: "doc.badge.clock.fill")
            } description: {
                Text("View older articles in Browse All")
            }
        } else {
            LazyVStack(alignment: .leading, pinnedViews: [.sectionHeaders]) {
                ForEach(Period.allCases) { period in
                    let articlesInRange = articles.forDates(in: period.dateRange)
                    if articlesInRange.count > 0 {
                        Section(header: SectionHeaderView(name: period.displayName)) {
                            ArticleCollectionView(articles: articlesInRange)
                        }
                    }
                }
            }
            .font(design.headerFont)
        }
    }
}

#Preview {
    RecentlyAddedView(articles: .samples)
        .environment(Presentation())
}

fileprivate typealias design = Design.Detail
