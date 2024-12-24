
// See LICENSE folder for this sample’s licensing information.

import ArticleStore
import SwiftUI

struct FeaturedView: View {
    let featured: [Article]
    let comingSoon: [Article]
    
    var body: some View {
        VStack(alignment: .leading, spacing: design.verticalSpacing) {
            if let hero {
                NavigationLink(value: hero.id) {
                    HeroView(article: hero)
                }
                .buttonStyle(OpaqueButtonStyle())
            }
            promotedView()
            if comingSoon.count > 0 {
                VStack(alignment: .leading) {
                    Divider()
                    Text("Coming Soon")
                        .font(design.comingSoonFont)
                        .padding(.vertical, design.comingSoonSpacing)
                    ArticleCollectionView(articles: comingSoon)
                        .disabled(true)
                }
                .padding(.horizontal, Design.Detail.padding)
            }
        }
        .padding(.bottom, Design.Detail.padding)
        .onAppear {
            if !promoted.isEmpty {
                firstPromoted = promoted[0]
            }
        }
    }
    
    @State private var firstPromoted: Article?
    
    private let hero: Article?
    private let promoted: Ring<Article>
    
    init(featured: [Article], comingSoon: [Article]) {
        self.featured = featured
        self.comingSoon = comingSoon
        self.hero = featured.first
        promoted = Ring(Array(featured.dropFirst()))
    }
    
    // MARK: - promoted view
    
    @ViewBuilder
    private func promotedView() -> some View {
        if let firstPromoted, let secondPromoted = promoted.item(after: firstPromoted) {
            HStack(alignment: .center, spacing: design.Promoted.gridSpacing) {
                Button {
                    cyclePromotedArticlesLeading()
                } label: {
                    Image(systemName: "chevron.compact.left")
                        .font(design.chevronFont)
                }
                .accessibilityLabel("Cycle left")
                NavigationLink(value: firstPromoted.id) {
                    PromotedView(article: firstPromoted)
                }
                NavigationLink(value: secondPromoted.id) {
                    PromotedView(article: secondPromoted)
                }
                Button {
                    cyclePromotedArticlesTrailing()
                } label: {
                    Image(systemName: "chevron.compact.right")
                        .font(design.chevronFont)
                }
                .accessibilityLabel("Cycle right")
            }
            .frame(maxWidth: .infinity)
            .padding(.top, design.Promoted.topPadding)
            .padding(.horizontal, design.Promoted.horizontalPadding)
        }
    }
    
    // MARK: - promoted functions
    
    private func cyclePromotedArticlesLeading() {
        guard let firstPromoted else { return }
        self.firstPromoted = promoted.item(before: firstPromoted)
    }
    
    private func cyclePromotedArticlesTrailing() {
        guard let firstPromoted else { return }
        self.firstPromoted = promoted.item(after: firstPromoted)
    }
}

#Preview {
    NavigationStack {
        ScrollView {
            FeaturedView(featured: .samples, comingSoon: .samples)
                .buttonStyle(.plain)
                .environment(Presentation())
        }
        .frame(width: 1200, height: 600)
    }
}

fileprivate typealias design = Design.Detail.Featured
