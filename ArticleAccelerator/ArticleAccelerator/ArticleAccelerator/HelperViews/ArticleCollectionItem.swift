// See LICENSE folder for this sample’s licensing information.

import ArticleStore
import SwiftUI

struct ArticleCollectionItem: View {
    let article: Article
    let isComplete: Bool
    
    var body: some View {
        Group {
            switch presentation.layoutStyle {
            case .grid:
                gridCell()
            case .list:
                listCell()
            }
        }
    }
    
    @Environment(Presentation.self) private var presentation
    @Environment(\.openWindow) private var openWindow
    
    private let durationFormatter = design.durationFormatter
    private var durationText: String {
        guard let text = durationFormatter.string(from: article.duration) else { return "" }
        return " | Duration: \(text)"
    }
    
    // MARK: - cell views
    
    private func gridCell() -> some View {
        VStack(alignment: .leading) {
            if let articleImage = image(for: article) {
                articleImage
                    .resizable()
                    .scaledToFit()
                    .completionStatus(isComplete)
                    .cornerRadius(design.Grid.cornerRadius)
                    .padding(.bottom, design.imageSpacing)
            }
            Text(LocalizedStringKey(article.hero.header))
                .lineLimit(design.Grid.headerLineLimit)
                .font(design.Grid.headerFont)
                .foregroundStyle(design.Grid.headerStyle)
            if let date = article.date {
                Text(date.formatted(date: .abbreviated, time: .omitted) + durationText)
                    .lineLimit(design.Grid.dateLineLimit)
                    .font(design.Grid.dateFont)
                    .foregroundStyle(design.Grid.dateStyle)
            }
        }
    }
    
    private func listCell() -> some View {
        HStack(spacing: design.listSpacing) {
            if let articleImage = image(for: article) {
                articleImage
                    .resizable()
                    .scaledToFit()
                    .completionStatus(isComplete, layoutStyle: .list)
                    .frame(width: design.List.width)
                    .cornerRadius(design.List.cornerRadius)
            }
            VStack(alignment: .leading) {
                Text(LocalizedStringKey(article.hero.header))
                    .lineLimit(design.List.headerLineLimit)
                    .font(design.List.headerFont)
                    .foregroundStyle(design.List.headerStyle)
                Text(LocalizedStringKey(article.hero.content))
                    .lineLimit(design.List.contentLineLimit)
                    .font(design.List.contentFont)
                    .foregroundStyle(design.List.contentStyle)
                if let date = article.date {
                    Text(date.formatted(date: .long, time: .omitted) + durationText)
                        .font(design.List.dateFont)
                        .foregroundStyle(design.List.dateStyle)
                }
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
    
    // MARK: - other functions
    
    private func image(for article: Article) -> Image? {
        let imageURL: URL
        switch presentation.layoutStyle {
        case .grid:
            imageURL = article.media.path.grid
        case .list:
            imageURL = article.media.path.list
        }
        guard let nsImage = NSImage(contentsOf: imageURL) else {
            return nil
        }
        return Image(nsImage: nsImage)
    }
}

#Preview {
    ArticleCollectionItem(article: .sample, isComplete: false)
        .environment(Presentation())
}

fileprivate typealias design = Design.Detail
