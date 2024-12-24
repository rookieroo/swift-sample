// See LICENSE folder for this sample’s licensing information.

import ArticleStore
import SwiftUI

struct PromotedView: View {
    let article: Article

    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                Text(LocalizedStringKey(article.hero.header))
                    .font(design.headerFont)
                    .lineLimit(design.headerLineLimit)
                    .padding(.vertical, design.headerPadding)
                Text(LocalizedStringKey(article.hero.content))
                    .lineLimit(design.contentLineLimit)
                    .font(design.contentFont)
            }
            .padding()
            Spacer()
            if let nsImage = NSImage(contentsOf: article.media.path.heroFull) {
                Image(nsImage: nsImage)
                    .resizable()
                    .scaledToFill()
                    .frame(width: design.imageDimension, height: design.imageDimension)
                    .clipped()
                    .accessibilityLabel(article.media.altText)
            }
        }
        .background(.quaternary)
        .clipShape(RoundedRectangle(cornerRadius: design.cornerRadius))
        .contextMenu(for: article.id)
    }
    
    @Environment(\.openWindow) private var openWindow
    @Environment(Presentation.self) private var presentation
}

#Preview {
    PromotedView(article: .sample)
}

fileprivate typealias design = Design.Detail.Featured.Promoted
