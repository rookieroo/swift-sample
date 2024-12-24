// See LICENSE folder for this sample’s licensing information.

import ArticleStore
import SwiftData
import SwiftUI
import WidgetKit

struct TrainingPlanView: View {
    var body: some View {
        Group {
            if selectableItems().isEmpty {
                VStack {
                    Spacer()
                    ContentUnavailableView("Drag an Article to the Training Plan", systemImage: "doc.plaintext.fill")
                    Spacer()
                }
                .dropDestination(for: String.self) { items, point in
                    didDrop(items: items, at: 0)
                    return true
                }
            } else {
                List(selection: $selectedItem) {
                    ForEach(trainingPlanItems) { item in
                        if isShowingItem(for: item.articleID),
                           let article = ArticleStore.shared.article(for: item.articleID) {
                            HStack {
                                itemView(for: article)
                                    .tag(item)
                                menuView(articleID: item.articleID)
                            }
                            .padding(.vertical)
                        }
                    }
                    .dropDestination(for: String.self) {
                        didDrop(items: $0, at: $1)
                    }
                    .onDelete(perform: removeTrainingPlanItems)
                    .onMove(perform: moveTrainingPlanItems)
                    .listRowInsets(design.rowInsets)
                }
                .onKeyPress(.downArrow, action: didPressDownArrow)
                .onKeyPress(.upArrow, action: didPressUpArrow)
                .onKeyPress(.return, action: didPressReturn)
            }
        }
    }
    
    @AppStorage("showCompletedArticles") private var showCompletedArticlesInTrainingPlan = true
    @Environment(\.modelContext) private var context
    @Environment(\.openURL) private var openURL
    @Environment(\.openWindow) private var openWindow
    @Environment(Presentation.self) private var presentation
    @Query private var articleStates: [ArticleState]
    @Query(sort: \TrainingPlanItem.index) private var trainingPlanItems: [TrainingPlanItem]
    @State private var selectedItem: TrainingPlanItem?
    
    // MARK: - other views
    private func itemView(for article: Article) -> some View {
        ArticleCollectionItem(article: article, isComplete: articleStates.isComplete(for: article.id))
            .buttonStyle(.plain)
    }
    
    private func menuView(articleID: Article.ID) -> some View {
        return Menu {
            Button(action: { openMainWindow(for: articleID) }) {
                Text("Open in Main Window")
            }
            Button(action: { openNewWindow(for: articleID) }) {
                Text("Open in New Window")
            }
            Divider()
            Button(action: { removeArticle(with: articleID) }) {
                Text("Remove from Training Plan")
            }
        } label: {
            Image(systemName: "ellipsis.circle.fill")
                .font(.title)
        }
        .buttonStyle(.plain)
    }
    
    // MARK: - selectable item functions
    
    private func firstSelectableItem() -> TrainingPlanItem? {
        trainingPlanItems.first(where: { isShowingItem(for: $0.articleID) })
    }
    
    private func nextSelectableItem() -> TrainingPlanItem? {
        guard let selectedItem else {
            return firstSelectableItem()
        }
        return Ring(selectableItems()).item(after: selectedItem)
    }
    
    private func previousSelectableItem() -> TrainingPlanItem? {
        guard let selectedItem else {
            return firstSelectableItem()
        }
        return Ring(selectableItems()).item(before: selectedItem)
    }
    
    private func selectableItems() -> [TrainingPlanItem] {
        trainingPlanItems.filter { isShowingItem(for: $0.articleID) }
    }
    
    // MARK: - keyboard navigation
    
    private func didPressDownArrow() -> KeyPress.Result {
        selectedItem = nextSelectableItem()
        return .handled
    }
    
    private func didPressUpArrow() -> KeyPress.Result {
        selectedItem = previousSelectableItem()
        return .handled
    }
    
    private func didPressReturn() -> KeyPress.Result {
        guard let selectedItem else {
            return .ignored
        }
        openMainWindow(for: selectedItem.articleID)
        return .handled
    }
    
    // MARK: - plan item functions
    
    private func removeTrainingPlanItems(at indexSet: IndexSet) {
        for indexToRemove in indexSet {
            context.delete(trainingPlanItems[indexToRemove])
            let indexRange = stride(from: indexToRemove+1, through: trainingPlanItems.count-1, by: 1)
            for indexToReorder in indexRange {
                let oldIndex = trainingPlanItems[indexToReorder].index
                let newIndex = oldIndex - 1
                if (0 ..< trainingPlanItems.count).contains(oldIndex) {
                    trainingPlanItems[oldIndex].index = newIndex
                }
            }
        }
        try? context.save()
        WidgetCenter.shared.reloadAllTimelines()
    }
    
    private func insertTrainingPlanItem(with articleID: Article.ID, at location: Int) {
        let indexRange = stride(from: trainingPlanItems.count-1, through: location, by: -1)
        for index in indexRange {
            let oldIndex = trainingPlanItems[index].index
            let newIndex = oldIndex + 1
            if (0 ..< trainingPlanItems.count).contains(oldIndex) {
                trainingPlanItems[oldIndex].index = newIndex
            }
        }
        let newTrainingPlanItem = TrainingPlanItem(articleID: articleID, index: location)
        context.insert(newTrainingPlanItem)
        try? context.save()
        WidgetCenter.shared.reloadAllTimelines()
    }
    
    private func moveTrainingPlanItems(fromOffsets: IndexSet, toOffset: Int) {
        var to = toOffset
        if let from = fromOffsets.first {
            let articleIDOfArticleWereRemoving = trainingPlanItems[from].articleID
            if from < toOffset {
                to -= 1
            }
            removeTrainingPlanItems(at: IndexSet(integer: from))
            insertTrainingPlanItem(with: articleIDOfArticleWereRemoving, at: to)
        }
    }
    
    // MARK: - window functions
    
    private func openNewWindow(for articleID: Article.ID) {
        openWindow(value: articleID)
    }
    
    private func openMainWindow(for articleID: Article.ID) {
        openURL(URL(string: "article://\(articleID)")!)
    }
    
    // MARK: - article functions
    
    private func removeArticle(with id: Article.ID) {
        guard let index = trainingPlanItems.firstIndex(where: { $0.articleID == id }) else {
            return
        }
        withAnimation {
            context.delete(trainingPlanItems[index])
            try? context.save()
        }
        WidgetCenter.shared.reloadAllTimelines()
    }
    
    private func isShowingItem(for articleID: Article.ID) -> Bool {
        !articleStates.isComplete(for: articleID) || showCompletedArticlesInTrainingPlan
    }
    
    // MARK: - other functions
    
    private func didDrop(items: [String], at location: Int) {
        if let item = items.first, !trainingPlanItems.contains(where: { $0.articleID == item } ) {
            insertTrainingPlanItem(with: item, at: location)
        }
    }
}

fileprivate typealias design = Design.TrainingPlan
