// See LICENSE folder for this sample’s licensing information.

import ArticleStore
import SwiftUI

struct MainView: View {
    @Binding var sidebarSelection: SidebarSelection
    @Binding var columnVisibility: NavigationSplitViewVisibility
    
    var body: some View {
        NavigationSplitView (columnVisibility: $columnVisibility){
            List(SidebarSelection.allCases, selection: $sidebarSelection) {
                selection in
                NavigationLink(value: selection) {
                    Label(selection.displayName, systemImage: selection.displayImageName)
                }
            }
        } detail: {
            NavigationStack(path: $navigationPath) {
                ScrollView {
                    DetailView(sidebarSelection: $sidebarSelection)
                }
                .buttonStyle(.plain)
                .navigationDestination(for: Article.ID.self) { articleID in
                    ArticleView(articleID: articleID)
                }
            }
            .navigationTitle(sidebarSelection.displayName)
        }
        .onOpenURL(perform: handleIncomingURL)
        .toolbar {
            if sidebarSelection.allowsList && navigationPath.isEmpty {
                @Bindable var presentation = presentation
                ToolbarItem {
                    Picker("Layout", selection: $presentation.layoutStyle) {
                        ForEach(CollectionLayoutStyle.allCases) { layoutStyle in
                            Label(layoutStyle.toolTipName, systemImage: layoutStyle.displayImageName)
                                .tag(layoutStyle)
                                .help(layoutStyle.toolTipName)
                                .accessibilityLabel(layoutStyle.toolTipName)
                        }
                    }
                    .pickerStyle(.inline)
                }
            }
        }
    }
    
    @Environment(\.openWindow) private var openWindow
    @Environment(Presentation.self) private var presentation
    @State private var navigationPath = NavigationPath()
    
    private func handleIncomingURL(_ url: URL) {
        switch url.scheme {
        case "article":
            guard let articleID = url.host(), let article = ArticleStore.shared.article(for: articleID) else {
                NSSound.beep()
                return
            }
            navigationPath = .init([article.id])

        case "article-browser":
            sidebarSelection = .browseAll
        
        default:
            return
        }
    }
}

#Preview {
    MainView(sidebarSelection: .constant(.browseAll), columnVisibility: .constant(.doubleColumn))
        .environment(Presentation())
        .frame(width: 800, height: 700)
}
