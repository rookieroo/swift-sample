// See LICENSE folder for this sample’s licensing information.

import Foundation

/// A store for retrieving training articles.
///
/// This store simulates a web service for retrieving training articles.
/// It provides a public API to retrieve articles individually or in groups.
/// The articles are read locally from a bundle, because implementing an actual web service is beyond the scope of this exercise.
public class ArticleStore {
    /// The singleton instance of this store.
    ///
    /// You'll never initialize a seperate instance of this class.
    /// Instead, always use this shared instance.
    static public var shared: ArticleStore { _shared }
    
    static private let _shared = ArticleStore()
    
    private var _articles: [Article]?
    private var _featured: [Article]?
    private var articleDates: [Date] {
        articles().compactMap { $0.date }
    }
    private var resourcesURL: URL {
        Bundle.module.bundleURL.appending(path: "Contents").appending(path: "Resources").appending(path: "Resources")
    }
    
    private init() { }
    
    /// Retrieve an article that corresponds to the given identifier.
    ///
    /// - Parameters:
    ///     - articleID: The identifier for the article you wish to retrieve.
    /// - Returns: The corresponding article, or `nil` if it doesn't exist.
    public func article(for articleID: String) -> Article? {
        articles().first(where: { $0.id == articleID })
    }
    
    /// Retrieve all currently released articles.
    ///
    /// - Returns: All articles that have been released so far.
    public func articles() -> [Article] {
        if _articles == nil {
            _articles = read()
            resetArticleDates()
        }
        return _articles?.filter { $0.date != nil } ?? [ ]
    }
    
    /// Retrieve previews of articles that have been announced, but are not yet released.
    ///
    /// - Returns: All articles that are coming soon.
    public func comingSoonArticles() -> [Article] {
        if _articles == nil {
            _articles = read()
            resetArticleDates()
        }
        return _articles?.filter { $0.date == nil } ?? [ ]
    }
    
    /// Retrieve all featured articles.
    ///
    /// - Returns: A curated list of articles.
    public func featuredArticles() -> [Article] {
        if let _featured {
            return _featured
        } else {
            let featuredIdentifiers = [
                "0B94CAC0-6D96-4A43-A62F-FB1E6264F538", // finding potable water
                "96CEB106-AE05-41E5-91C0-58313BBB6E94", // biodome cuisine
                "0BDFC748-694C-450C-A866-B3E210C6A19D", // boosting self-esteem
                "4E0B574B-1848-4172-BD8B-FD4E85D66FF7", // adjusting to life in the biodome
                "BAEA0818-D488-4736-8FA5-BA2FF975696A", // working well with others
                "5AA19FE3-3678-4203-90C4-9F8527F68D53", // inclusion and robots
                "99F98391-ABCE-46C4-B4C3-E9A49DA8F91B", // leisure activities
            ]
            let articles = self.articles()
            var featured = [Article]()
            for identifier in featuredIdentifiers {
                guard let article = articles.first(where: { $0.id == identifier }) else {
                    continue
                }
                featured.append(article)
            }
            _featured = featured
            return featured
        }
    }
    
    private func read() -> [Article] {
        var articles: [Article] = []
        let decoder = JSONDecoder()
        decoder.userInfo[.init(rawValue: "resourcesURL")!] = resourcesURL
        do {
            let files = try FileManager.default.contentsOfDirectory(atPath: resourcesURL.path())
            let articleFiles = files.filter { $0.hasSuffix("json") }
            for articleFile in articleFiles {
                let articleURL = resourcesURL.appending(path: articleFile)
                do {
                    let data = try Data(contentsOf: articleURL)
                    let article = try decoder.decode(Article.self, from: data)
                    articles.append(article)
                } catch {
                    print("Error reading data for article...skipping.")
                }
            }
        } catch {
            fatalError("Error reading articles. Stopping app.")
        }
        return articles
    }
    
    private func resetArticleDates() {
        guard let _articles else { return }
        let dates = articleDates.sorted()
        let adjustment = Date.now.timeIntervalSince(dates.last!)
        for index in 0..<_articles.count {
            guard let originalDate = _articles[index].date else { continue }
            let adjustedDate = originalDate.advanced(by: adjustment)
            let weightedAdjustment = adjustedDate.timeIntervalSince(.now) * 2.7
            let weightedAdjustedDate = adjustedDate.advanced(by: weightedAdjustment)
            self._articles?[index].date = weightedAdjustedDate
        }
    }
}
