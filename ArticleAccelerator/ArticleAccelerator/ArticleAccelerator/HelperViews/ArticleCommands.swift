// See LICENSE folder for this sample’s licensing information.

import ArticleStore
import SwiftUI
import WidgetKit

struct ArticleCommands: Commands {
    @Binding var presentation: Presentation
    @Binding var sidebarSelection: SidebarSelection
    @Binding var columnVisibility: NavigationSplitViewVisibility
    let enableTrainingPlanCommands: Bool
    
    var body: some Commands {
        CommandMenu("Article") {
            Button("Toggle Bookmark") {
                if let article {
                    stateManager.toggleBookmark(for: article.id)
                }
            }
            .disabled(article == nil)
            .keyboardShortcut("B", modifiers: [.command])
        }
        CommandGroup(replacing: .undoRedo) {}
        CommandGroup(before: .sidebar) {
            ForEach(Array(toggles.indices), id: \.self) { index in
                Toggle(toggles[index].menuCommand, isOn: bindingForToggleState(at: index))
                    .keyboardShortcut(toggles[index].shortcut)
            }
            .disabled(sidebarSelection == .featured)
            Divider()
            Button("Featured") {
                sidebarSelection = .featured
            }
            .keyboardShortcut("1", modifiers: [.command])
            Button("My Stuff") {
                sidebarSelection = .myStuff
            }
            .keyboardShortcut("2", modifiers: [.command])
            Button("Recently Added") {
                sidebarSelection = .recentlyAdded
            }
            .keyboardShortcut("3", modifiers: [.command])
            Button("Browse All") {
                sidebarSelection = .browseAll
            }
            .keyboardShortcut("4", modifiers: [.command])
            Divider()
            Button(sidebarVisibilityCommand) {
                columnVisibility = columnVisibility == .all ? .detailOnly : .all
            }
            .keyboardShortcut("S", modifiers: [.command, .control])
            Button(showCompletedArticlesCommand) {
                showCompletedArticlesInTrainingPlan.toggle()
                WidgetCenter.shared.reloadAllTimelines ()
            }
            .keyboardShortcut("C", modifiers: [.command])
            .disabled(!enableTrainingPlanCommands)
            Divider()
        }
    }
    
    @AppStorage("showCompletedArticles") private var showCompletedArticlesInTrainingPlan = true
    @Environment(\.articleStateManager) private var stateManager
    @FocusedValue(\.article) private var article: Article?
    @State private var displayAsGrid: Bool = true
    @State private var displayAsList: Bool = false
    @State private var presentationType: Int = 0
    @State var toggles: [ToggleState] = {
        CollectionLayoutStyle.togglesForPresentationStyles()
    }()
    
    private var showCompletedArticlesCommand: String {
        showCompletedArticlesInTrainingPlan ? "Hide Completed Articles in Training Plan" : "Show Completed Articles in Training Plan"
    }
    
    private var sidebarVisibilityCommand: String {
        columnVisibility == .all ? "Hide Sidebar" : "Show Sidebar"
    }
    
    private func bindingForToggleState(at index: Int) -> Binding<Bool> {
        return Binding(
            get: {
                toggles[index].isOn
            },
            set: { _ in
                for toggleIndex in toggles.indices {
                    if toggleIndex == index {
                        toggles[index].isOn = true
                    } else {
                        toggles[toggleIndex].isOn = false
                    }
                }
                presentation.layoutStyle = CollectionLayoutStyle.presentation(for: toggles)
            }
        )
    }
}

extension ArticleCommands {
    struct ToggleState: Identifiable {
        let menuCommand: String
        var isOn = false
        let id = UUID()
        let shortcut: KeyboardShortcut
    }
}
