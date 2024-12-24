// See LICENSE folder for this sample’s licensing information.

import Foundation

/// A path used to represent an on-disk location of a resource.
public struct Path: Codable, Hashable {
    /// The location of the resource sized to display in a list.
    public let list: URL
    /// The location of the resource sized to display in a grid.
    public let grid: URL
    /// The location of the resource sized to display in a promoted view.
    public let heroMini: URL
    /// The location of the resource sized to display in a hero view.
    public let heroFull: URL
    /// The location of the original, full-sized resource.
    public let original: URL
    
    public init(from decoder: Decoder) throws {
        guard let key = CodingUserInfoKey(rawValue: "resourcesURL"),
              let resourcesURL = decoder.userInfo[key] as? URL else {
            throw CocoaError(.coderReadCorrupt)
        }

        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        self.list = try resourcesURL.appending(path: container.decode(URL.self, forKey: .list).path())
        self.grid = try resourcesURL.appending(path: container.decode(URL.self, forKey: .grid).path())
        self.heroMini = try resourcesURL.appending(path: container.decode(URL.self, forKey: .heroMini).path())
        self.heroFull = try resourcesURL.appending(path: container.decode(URL.self, forKey: .heroFull).path())
        self.original = try resourcesURL.appending(path: container.decode(URL.self, forKey: .original).path())
    }
}
