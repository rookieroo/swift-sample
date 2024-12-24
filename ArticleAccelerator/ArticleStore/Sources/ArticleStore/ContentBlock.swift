// See LICENSE folder for this sample’s licensing information.

import Foundation

/// A block of content that can be used independently or in a collection.
public struct ContentBlock: Codable, Hashable {
    /// A unique identifier describing this block.
    public let id: String
    /// The header or title associated with this block.
    public let header: String
    /// The body of this block.
    public let content: String
}
