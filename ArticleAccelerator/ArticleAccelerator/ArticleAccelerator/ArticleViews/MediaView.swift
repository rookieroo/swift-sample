// See LICENSE folder for this sample’s licensing information.

import ArticleStore
import SwiftUI

struct MediaView: View {
    let media: Media
    
    var body: some View {
        switch media {
        case .image(let path, _):
            if let nsImage = NSImage(contentsOf: path.heroFull) {
                Image(nsImage: nsImage)
                    .resizable()
                    .scaledToFill()
                    .accessibilityLabel(media.altText)
            }
        case .video(_, _):
            ThreeDView(media: media)
                .aspectRatio(design.videoAspectRatio, contentMode: .fill)
                .accessibilityLabel(media.altText)
        default:
            VStack(alignment: .leading) {
                ThreeDView(media: media)
                    .aspectRatio(design.videoAspectRatio, contentMode: .fill)
                    .accessibilityLabel(media.altText)
                    .clipShape(RoundedRectangle(cornerRadius: design.cornerRadius))
                VStack(alignment: .leading) {
                    Text("Move left, right, up, or down: Click and drag.")
                        .font(.caption)
                    Text("Zoom in or out: Press and hold the Option key, pinch with two fingers on a trackpad.")
                        .font(.caption)
                }
                .padding(4)
            }
        }
    }
}

#Preview {
    MediaView(media: .sample)
}

#Preview {
    MediaView(media: .sampleVideo)
}

fileprivate typealias design = Design.Article.Media
