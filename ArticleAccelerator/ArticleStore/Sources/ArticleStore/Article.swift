// See LICENSE folder for this sample’s licensing information.

import Foundation

/// A training article that contains media and text about a topic.
public struct Article: Codable, Hashable {
    /// A unique identifier describing this article.
    public let id: String
    /// The hero media for this article.
    public let media: Media
    /// The release date of this article.
    public internal(set) var date: Date?
    /// The anticipated time required to read this article.
    public let duration: TimeInterval
    /// The hero title and content for this article.
    public let hero: ContentBlock
    /// The body of this article.
    public let body: [ContentBlock]
    /// A knowledge check question about this article.
    public let question: Question?
    /// A flag indicating if this article has been released.
    public var isReleased: Bool { date != .none }
}
