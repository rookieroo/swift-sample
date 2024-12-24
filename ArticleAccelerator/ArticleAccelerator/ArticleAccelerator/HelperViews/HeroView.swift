// See LICENSE folder for this sample’s licensing information.

import ArticleStore
import SwiftUI

struct HeroView: View {
    let article: Article
    
    var body: some View {
            if let nsImage = NSImage(contentsOf: article.media.path.heroFull) {
                GeometryReader { geometry in
                    Image(nsImage: nsImage)
                        .resizable()
                        .scaledToFill()
                        .frame(width: geometry.size.width, height: geometry.size.height)
                        .accessibilityLabel(article.media.altText)
                        .overlay(alignment: .topLeading) {
                            leadingPanel(width: geometry.size.width)
                        }
                }
                .aspectRatio(design.imageAspectRatio, contentMode: .fill)
                .clipped()
                .contextMenu(for: article.id)
            }
    }
    
    @Environment(\.openWindow) private var openWindow
    @Environment(Presentation.self) private var presentation
    
    private func leadingPanel(width: CGFloat) -> some View {
        VStack(alignment: .leading, spacing: design.headerSpacing) {
            Text("ESSENTIAL READING")
                .font(design.captionFont)
            Text(LocalizedStringKey(article.hero.header))
                .font(design.headerFont)
                .lineLimit(design.headerLineLimit)
            Text(LocalizedStringKey(article.hero.content))
                .font(design.contentFont)
                .foregroundStyle(design.contentFontStyle)
                .lineLimit(design.contentLineLimit)
                .padding(.top, design.contentPadding)
            Spacer()
        }
        .frame(maxWidth: width * design.leadingPanelWidthFactor, maxHeight: .infinity)
        .padding(design.headerPadding)
        .background(.thinMaterial)
    }
}

#Preview {
    HeroView(article: .sample)
}

fileprivate typealias design = Design.Detail.Featured.Hero
