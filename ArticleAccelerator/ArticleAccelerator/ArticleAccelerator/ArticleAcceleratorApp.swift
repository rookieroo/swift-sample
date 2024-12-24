// See LICENSE folder for this sample’s licensing information.

import ArticleStore
import SwiftData
import SwiftUI
import TipKit

@main
struct ArticleAcceleratorApp: App {
    var body: some Scene {
        Window("Article Browser", id: "Article Browser") {
            MainView(sidebarSelection: $sidebarSelection, columnVisibility: $columnVisibility)
                .environment(\.articleStateManager, sharedStateManager)
                .environment(presentation)
                .frame(minWidth: design.minWindowWidth, minHeight: design.minWindowHeight)
                .handlesExternalEvents(
                    preferring: [],
                    allowing: ["article"]
                )
        }
        .handlesExternalEvents(matching: ["article-browser"])
        .modelContainer(sharedArticleContainer)
        .commands {
            ArticleCommands(presentation: $presentation, sidebarSelection: $sidebarSelection, columnVisibility: $columnVisibility, enableTrainingPlanCommands: trainingViewInFocus)
        }
        .defaultAppStorage(defaults)
        .windowToolbarStyle(.unified)
        
        Window("Training Plan", id: "TrainingPlanWindow") {
            TrainingPlanView()
                .modelContainer(sharedArticleContainer)
                .environment(Presentation(layoutStyle: .list))
                .focused($trainingViewInFocus)
                .frame(minHeight: design.TrainingPlan.windowMinHeight)
                .frame(width: design.TrainingPlan.windowWidth)
        }
        .windowResizability(.contentSize)
        .defaultAppStorage(defaults)
        
        WindowGroup(for: Article.ID.self) { $articleID in
            if let articleID {
                ArticleView(articleID: articleID)
                    .handlesExternalEvents(
                        preferring: ["article://\(articleID)"],
                        allowing: []
                    )
                    .environment(\.articleStateManager, sharedStateManager)
            }
        }
        .modelContainer(sharedArticleContainer)
        .windowToolbarStyle(.unified)
        
        Settings {
            SettingsView()
                .navigationTitle("Article Accelerator Settings")
        }
        .modelContainer(sharedArticleContainer)
    }
    
    @FocusState private var trainingViewInFocus: Bool
    @State private var sidebarSelection: SidebarSelection = .featured
    @State private var columnVisibility: NavigationSplitViewVisibility = .all
    @State private var presentation = Presentation()
    
    private let sharedArticleContainer: ModelContainer
    private let sharedStateManager: ArticleStateManager
    private var defaults: UserDefaults { UserDefaults.articleAccleratorGroup }
    
    init() {
        let modelContainer = Self.articleContainer()
        let modelContext = ModelContext(modelContainer)
        self.sharedArticleContainer = modelContainer
        self.sharedStateManager = ArticleStateManager(modelContext: modelContext)
        
        if defaults.bool(forKey: SettingsView.shouldResetTipsKey) {
            setupTipsForTesting()
        }
        
        // Uncomment the following line to make tips appear immediately.
        //Tips.showAllTipsForTesting()
        
        // Configure and load tips in the app.
        try? Tips.configure()
    }
    
    private func setupTipsForTesting() {
        defaults.set(false, forKey: SettingsView.shouldResetTipsKey)
        do {
            try Tips.resetDatastore()
        } catch {
            fatalError(error.localizedDescription)
        }
    }
    
    static private func articleContainer() -> ModelContainer {
        do {
            return try ModelContainer(for: ArticleState.self, TrainingPlanItem.self)
        } catch {
            fatalError("Could not create ModelContainer: \(error)")
        }
    }
}

fileprivate typealias design = Design.App
