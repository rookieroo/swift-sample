// See LICENSE folder for this sample’s licensing information.

import ArticleStore
import SwiftUI

struct MyStuffView: View {
    let bookmarked: [Article]
    let completed: [Article]
    
    var body: some View {
        if bookmarked.isEmpty, completed.isEmpty {
            ContentUnavailableView {
                Label("Nothing to show yet", systemImage: "doc.plaintext.fill")
            } description: {
                Text("Save your favorite articles and\nview a history of your completed work.")
            }
        } else {
            VStack(alignment: .leading) {
                Section(header: SectionHeaderView(name: "Bookmarks")) {
                    if bookmarked.isEmpty {
                        Text("No bookmarks yet. Click the bookmarks button in an article.")
                            .font(design.contentUnavailableFont)
                            .foregroundStyle(design.contentUnavailableStyle)
                    } else {
                        ArticleCollectionView(articles: bookmarked)
                    }
                }
                Spacer(minLength: 20)
                Section(header: SectionHeaderView(name: "Completed")) {
                    if completed.isEmpty {
                        Text("No completed articles yet. Pass the quiz at the end of an article.")
                            .font(design.contentUnavailableFont)
                            .foregroundStyle(design.contentUnavailableStyle)
                    } else {
                        ArticleCollectionView(articles: completed)
                    }
                }
            }
            .font(design.headerFont)
        }
    }
}

#Preview {
    MyStuffView(bookmarked: .samples, completed: .samples)
        .environment(Presentation())
}
#Preview {
    MyStuffView(bookmarked: [], completed: [])
        .environment(Presentation())
}

fileprivate typealias design = Design.Detail
