// See LICENSE folder for this sample’s licensing information.

import ArticleStore
import Foundation

extension [Article] {
    func article(for identifier: Article.ID) -> Article? {
        first(where: { $0.id == identifier })
    }
    
    func bookmarked(in articleStates: [ArticleState]) -> Self {
        filter { article in
            articleStates.contains { ($0.articleID == article.id) && $0.isBookmark }
        }
    }
    
    func completed(in articleStates: [ArticleState]) -> Self {
        filter { article in
            articleStates.contains { ($0.articleID == article.id) && $0.isComplete }
        }
    }
    
    func forDates(in range: ClosedRange<Date>) -> [Article] {
        filter { article in
            guard let date = article.date else { return false }
            return range.contains(date)
        }
    }
    
    func matchingSearchResults(_ search: String) -> Self {
        guard !search.isEmpty else {
            return sorted { (lhs, rhs) in
                lhs.hero.header < rhs.hero.header
            }
        }
        return map { article in
            (article, article.searchScore(search))
        }
        .filter { (_, score) in
            score > 0
        }
        .sorted { (lhs, rhs) in
            lhs.1 > rhs.1
        }
        .map { (article, _) in
            article
        }
    }
}
