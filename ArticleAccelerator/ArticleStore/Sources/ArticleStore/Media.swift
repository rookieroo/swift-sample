// See LICENSE folder for this sample’s licensing information.

import Foundation

/// A media object. It can be an image, a video, or a 3D model.
public enum Media: Codable, Hashable {
    /// This case represents an image and contains an associated path to the model.
    case image(Path, String)
    /// This case represents a video and contains an associated path to the model.
    case video(Path, String)
    /// This case represents a 3D model and contains an associated path to the model.
    case threeD(Path, String)
    
    /// Text describing this media
    public var altText: String {
        switch self {
        case .image(_, let altText):
            return altText
        case .video(_, let altText):
            return altText
        case .threeD(_, let altText):
            return altText
        }
    }
    /// A path to the media object.
    public var path: Path {
        switch self {
        case .image(let path, _):
            return path
        case .video(let path, _):
            return path
        case .threeD(let path, _):
            return path
        }
    }
}
