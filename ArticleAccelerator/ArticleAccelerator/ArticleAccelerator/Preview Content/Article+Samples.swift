// See LICENSE folder for this sample’s licensing information.

import ArticleStore
import Foundation

extension [Article] {
    static var samples: [Article] {
        ArticleStore.shared.articles()
    }
}

extension Article {
    static var sample: Article {
        ArticleStore.shared.articles().first!
    }
}

extension Media {
    static var sample: Media {
        Article.sample.media
    }
    static var sampleVideo: Media {
        let videoArticle = ArticleStore.shared.articles().first(where: { article in
            if case .video = article.media {
                return true
            }
            return false
        })!
        return videoArticle.media
    }
}

extension Question {
    static var sample: Question {
        let article = ArticleStore.shared.articles().first { article in
            article.question != nil
        }!
        return article.question!
    }
}

extension String {
    static var sampleArticleID: Article.ID {
        ArticleStore.shared.articles().first!.id
    }
}
