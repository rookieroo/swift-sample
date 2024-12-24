// See LICENSE folder for this sample’s licensing information.

import ArticleStore
import SwiftData
import SwiftUI
import TipKit

struct ArticleView: View {
    let articleID: Article.ID
    
    @ScaledMetric(wrappedValue: design.heroHeaderReferenceSize, relativeTo: design.heroHeaderReferenceFont) var heroHeaderFontSize: CGFloat
    @ScaledMetric(wrappedValue: design.sectionHeaderReferenceSize, relativeTo: design.sectionHeaderReferenceFont) var sectionHeaderFontSize: CGFloat
    
    let article: Article?
    
    private let addBookmarkTip = AddBookmarkTip()
    private let surfaceHighlightsTip = SurfaceHighlightsTip()
    private let surfaceHighlightsInspectorTip = SurfaceHighlightsInspectorTip()
    
    init(articleID: Article.ID) {
        self.articleID = articleID
        self.article = ArticleStore.shared.article(for: articleID) ?? nil
        _articleStates = Query(filter: #Predicate { $0.articleID == articleID } )
    }
    
    var body: some View {
        if let article {
            ScrollView {
                VStack(alignment: .leading, spacing: design.verticalSpacing) {
                    Group {
                        MediaView(media: article.media)
                            .clipShape(RoundedRectangle(cornerRadius: design.Media.cornerRadius))
                            .padding(.bottom, design.mediaBottomSpacing)
                        TipView(surfaceHighlightsTip, arrowEdge: .bottom)  { action in
                            if action.id == "tryIt" {
                                addSampleHighlight()
                            }
                            if action.id == "done" {
                                removeSampleHighlight()
                            }
                        }
                        .task {
                            for await status in surfaceHighlightsTip.statusUpdates {
                                if status == .invalidated(.tipClosed) {
                                    guard let programmaticallyAddedHighlightID,
                                          let index = articleStates.state(for: article.id)?.highlights.firstIndex(where: { $0.id == programmaticallyAddedHighlightID })
                                    else {
                                        continue
                                    }
                                    articleStates.state(for: article.id)?.highlights.remove(at: index)
                                }
                            }
                        }
                        SelectableTextWrapper(text: NSAttributedString(content), highlight: $highlight)
                        if let question = article.question {
                            QuestionView(question: question,
                                         isComplete: { isComplete },
                                         correctAnswerAction: markAsComplete)
                        }
                    }
                    .frame(width: design.contentWidth, alignment: .leading)
                }
                .onChange(of: highlight) { oldValue, newValue in
                    if let newValue {
                        addHighlight(newValue)
                        Task {
                            await SurfaceHighlightsInspectorTip.didAddHighlight.donate()
                        }
                    }
                    highlight = nil
                }
                .frame(maxWidth: .infinity)
                .padding(Design.Detail.padding)
            }
            .task {
                await AddBookmarkTip.didViewArticle.donate()
            }
            .onOpenURL { url in
                if url.scheme != "article" || url.host() != article.id {
                    NSSound.beep()
                }
            }
            .inspector(isPresented: $showingInspector) {
                if let state = articleState, state.highlights.count > 0 {
                    HighlightInspector(articleContent: content, state: state)
                } else {
                    ContentUnavailableView("No Highlights or Notes",
                                           systemImage: "highlighter",
                                           description: Text("Select text in an article, Control-click, and choose a highlighter color.")
                    )
                }
            }
            .sheet(item: $selection) { selection in
                VStack {
                    Text(selection.range.description)
                        .padding()
                    Button(action: { self.selection = nil }) {
                        Text("Dismiss")
                    }
                }
            }
            .toolbar(id: "article-view") {
                ToolbarItem(id: "bookmark") {
                    Button {
                        stateManager.toggleBookmark(for: articleID)
                        addBookmarkTip.invalidate(reason: .actionPerformed)
                    } label: {
                        Image(systemName: (articleState?.isBookmark ?? false) ? "bookmark.fill" : "bookmark")
                            .popoverTip(addBookmarkTip)
                    }
                    .help((articleState?.isBookmark ?? false) ? "Remove from Bookmarks" : "Add to Bookmarks")
                }
                
                ToolbarItem(id: "highlights") {
                    Button {
                        showingInspector.toggle()
                    } label: {
                        Label("Toggle Highlights Pane", systemImage: "highlighter")
                            .popoverTip(surfaceHighlightsInspectorTip)
                    }
                    .help(showingInspector ? "Hide Highlights Pane" : "Show Highlights Pane")
                }
            }
            .focusedSceneValue(\.article, article)
            .navigationTitle(article.hero.header)
            .onChange(of: showingInspector) { oldValue, newValue in
                if newValue {
                    surfaceHighlightsInspectorTip.invalidate(reason: .actionPerformed)
                }
            }
            .onDisappear {
                if programmaticallyAddedHighlightID != nil {
                    removeSampleHighlight()
                }
            }
        } else {
            ContentUnavailableView("Article isn't available.", systemImage: "exclamationmark.circle")
        }
    }
    
    @Environment(\.articleStateManager) private var stateManager
    @Environment(\.modelContext) private var modelContext
    @Environment(\.colorScheme) private var colorScheme
    @Query private var articleStates: [ArticleState]
    @State private var highlight: Highlight?
    @State private var programmaticallyAddedHighlightID: Highlight.ID?
    @State private var showingInspector = false
    @State private var selection: Highlight?
    
    private var articleState: ArticleState? {
        articleStates.first(where: { $0.articleID == articleID })
    }
    private var content: AttributedString {
        let content = initialContent
        if let state = articleState, !state.highlights.isEmpty {
            let input = NSMutableAttributedString(content)
            let result = applyHighlights(state.highlights, to: input)
            return AttributedString(result)
        }
        return content
    }
    private var isComplete: Bool { articleState?.isComplete ?? false }
    
    private func markAsComplete() {
        stateManager.markAsComplete(for: articleID)
    }
    
    // MARK: - highlight functions
    
    private func addHighlight(_ highlight: Highlight) {
        guard let state = articleState else {
            stateManager.addHighlight(highlight, to: articleID)
            return
        }
        var intersectingHighlights = state.highlights.highlightsIntersectingRange(highlight.range)
        if intersectingHighlights.isEmpty {
            state.highlights.append(highlight)
        } else {
            intersectingHighlights.append(highlight)
            intersectingHighlights.sort { lhs, rhs in
                lhs.range.lowerBound < rhs.range.lowerBound
            }
            let lowerBound = intersectingHighlights.reduce(Int.max) {
                $1.range.lowerBound < $0 ? $1.range.lowerBound : $0
            }
            let upperBound = intersectingHighlights.reduce(Int.min) {
                $1.range.upperBound > $0 ? $1.range.upperBound : $0
            }
            let range = Range<Int>(uncheckedBounds: (lowerBound, upperBound))
            let note = intersectingHighlights.reduce("") {
                if $1.note.isEmpty {
                    return $0
                } else if $0.isEmpty {
                    return $1.note
                } else {
                    return $0 + "\n" + $1.note
                }
            }
            
            for highlight in intersectingHighlights {
                stateManager.removeHighlight(highlight)
            }
            
            let combinedHighlight = Highlight(id: UUID(), range: range, style: highlight.style, note: note)
            state.highlights.append(combinedHighlight)
        }
    }
    
    private func applyHighlights(_ highlights: [Highlight], to content: NSMutableAttributedString) -> NSAttributedString {
        for highlight in highlights {
            let range = NSRange(location: highlight.range.lowerBound, length: highlight.range.upperBound - highlight.range.lowerBound)
            content.addAttribute(NSAttributedString.Key.backgroundColor, value: highlight.backgroundColor, range: range)
            content.addAttribute(NSAttributedString.Key.foregroundColor, value: highlight.foregroundColor, range: range)
        }
        return content
    }
    
    // MARK: - highlight functions for tips
    
    private func addSampleHighlight() {
        if programmaticallyAddedHighlightID == nil {
            guard let article else { return }
            let lengthOfTitle = article.hero.header.count
            let range = Range<Int>(uncheckedBounds: (0, lengthOfTitle))
            let highlight = Highlight(id: UUID(), range: range, style: .yellow)
            articleStates.state(for: articleID, createIn: modelContext)?.highlights.append(highlight)
            programmaticallyAddedHighlightID = highlight.id
        } else {
            guard let highlight = articleStates.state(for: articleID)?.highlights.first(where: { $0.id == programmaticallyAddedHighlightID }) else { return }
            highlight.applyRandomStyle()
        }
    }
    
    private func removeSampleHighlight() {
        guard let programmaticallyAddedHighlightID,
              let state = articleStates.state(for: articleID),
              let highlightIndex = state.highlights.firstIndex(where: { $0.id == programmaticallyAddedHighlightID }) else { return }
        state.highlights.remove(at: highlightIndex)
        surfaceHighlightsTip.invalidate(reason: .actionPerformed)
    }
}

#Preview {
    ArticleView(articleID: .sampleArticleID)
        .modelContainer(for: ArticleState.self, inMemory: true)
}

fileprivate typealias design = Design.Article
