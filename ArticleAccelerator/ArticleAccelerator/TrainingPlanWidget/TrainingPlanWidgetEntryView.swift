// See LICENSE folder for this sample’s licensing information.

import ArticleStore
import SwiftData
import SwiftUI
import WidgetKit

struct TrainingPlanWidgetEntryView : View {
    var entry: Provider.Entry
    
    var body: some View {
        VStack {
            switch widgetFamily {
            case .systemSmall:
                if let article = trainingPlanArticles.first {
                    Link(destination:  URL(string: "article://\(article.id)")!) {
                        smallWidget(for: article)
                    }
                } else {
                    contentUnavailableSmallWidget()
                }
            case .systemMedium, .systemLarge:
                let displayCount = widgetFamily == .systemLarge ? min(trainingPlanArticles.count, 3) : min(trainingPlanArticles.count, 2)
                VStack(alignment: .leading, spacing: design.verticalSpacing) {
                    widgetHeaderView()
                        .padding(.vertical, 10)
                    if !trainingPlanArticles.isEmpty {
                        ForEach(trainingPlanArticles[0 ..< displayCount]) { article in
                            widgetRowView(for: article)
                        }
                        Spacer()
                    } else {
                        contentUnavailableWidget()
                    }
                }
                
            default:
                Image(systemName: "rectangle.slash.fill")
            }
        }
    }
    
    var trainingPlanArticles: [Article] {
        trainingPlanItems.compactMap { ArticleStore.shared.article(for: $0.articleID) }.filter {
            if let state = articleStates.state(for: $0.id), state.isComplete {
                return isShowingCompleted()
            } else {
                return true
            }
        }
    }
    var widgetDisplayURL: URL {
        if trainingPlanArticles.count > 0 {
            return URL(string: "article://\(trainingPlanArticles[0].id)")!
        } else {
            return URL(string: "article-browser://")!
        }
    }
    
    @Environment(\.widgetFamily) private var widgetFamily
    @Query private var articleStates: [ArticleState]
    @Query(sort: \TrainingPlanItem.index) private var trainingPlanItems: [TrainingPlanItem]
    
    private let durationFormatter = Design.Detail.durationFormatter
    
    func image(for article: Article) -> Image? {
        let imageURL = article.media.path.list
        guard let nsImage = NSImage(contentsOf: imageURL) else {
            return nil
        }
        return Image(nsImage: nsImage)
    }
    
    func isShowingCompleted() -> Bool {
        let defaults = UserDefaults.articleAccleratorGroup
        return defaults.bool(forKey: "showCompletedArticles")
    }
    
    fileprivate func contentUnavailableSmallWidget() -> some View {
        VStack {
            Image(nsImage: NSImage(named: NSImage.applicationIconName)!)
                .resizable()
                .scaledToFit()
            Capsule()
                .fill(design.launchButtonFill)
                .overlay {
                    VStack {
                        Text("Launch")
                        Text("Training")
                    }
                    .font(design.titleFont(for: widgetFamily))
                }
        }
        .widgetURL(widgetDisplayURL)
    }
    
    fileprivate func contentUnavailableWidget() -> some View {
        VStack(alignment: .leading, spacing: design.emptySpacing) {
            Text("Your training plan is empty")
                .font(design.contentUnavailableFont)
            Text("View Article Browser")
            Spacer()
        }
        .padding()
    }
    
    private func durationText(for duration: TimeInterval) -> String {
        guard let text = durationFormatter.string(from: duration) else {
            return ""
        }
        return " | Duration: \(text)"
    }
    
    fileprivate func smallWidget(for article: Article) -> some View {
        return ZStack(alignment: .leading) {
            if let articleImage = image(for: article) {
                articleImage
                    .resizable()
                    .scaledToFill()
                    .frame(
                        width: design.Small.imageSize,
                        height: design.Small.imageSize,
                        alignment: .center)
                    .clipped()
            }
            Color.black.opacity(design.Small.shaderOpacity)
            VStack(alignment: .leading) {
                Spacer()
                Text(article.hero.header)
                    .font(design.heroHeaderFont(for: widgetFamily))
                    .foregroundStyle(design.Small.fontColor)
                    .lineLimit(design.lineLimit)
                    .padding()
                    .padding(.bottom, design.bottomSpacing)
            }
        }
        .overlay(alignment: .topTrailing) {
            Image(nsImage: NSImage(named: NSImage.applicationIconName)!)
                .resizable()
                .frame(width: design.heroHeaderIconSize, height: design.heroHeaderIconSize)
                .padding(design.iconSpacing)
        }
    }
    
    fileprivate func widgetHeaderView() -> some View {
        HStack {
            Text("JurassiCo Training Plan")
            Spacer()
            Image(nsImage: NSImage(named: NSImage.applicationIconName)!)
                .resizable()
                .frame(width: design.heroHeaderIconSize, height: design.heroHeaderIconSize)
        }
        .font(design.titleFont(for: widgetFamily))
    }
    
    fileprivate func widgetRowView(for article: Article) -> Link<some View> {
        return Link(destination:  URL(string: "article://\(article.id)")!) {
            HStack(alignment: .center) {
                if let articleImage = image(for: article) {
                    articleImage
                        .resizable()
                        .scaledToFill()
                        .frame(
                            width: (widgetFamily == .systemMedium) ? design.Medium.imageSize : design.Large.imageSize,
                            height: (widgetFamily == .systemMedium) ? design.Medium.imageSize : design.Large.imageSize,
                            alignment: .center
                        )
                        .cornerRadius(design.imageCornerRadius)
                        .clipped()
                }
                VStack(alignment: .leading) {
                    Text(article.hero.header)
                        .font(design.heroHeaderFont(for: widgetFamily))
                        .lineLimit(design.lineLimit)
                    if let date = article.date {
                        Text(date.formatted(date: .abbreviated, time: .omitted) + durationText(for: article.duration))
                            .lineLimit(design.dateLineLimit)
                            .font(design.dateFont)
                            .foregroundStyle(design.dateStyle)
                    }
                }
                Spacer()
            }
            .frame(maxWidth: .infinity, alignment: .leading)
        }
    }
}

fileprivate typealias design = Design.TrainingPlan.Widget
