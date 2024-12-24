// See LICENSE folder for this sample’s licensing information.

import SwiftUI
import WidgetKit

struct SettingsView: View {
    
    static var shouldResetTipsKey: String { "shouldResetTips" }

    var body: some View {
        Grid {
            GridRow(alignment: .firstTextBaseline) {
                    Text("Training plan:")
                    .gridColumnAlignment(.trailing)
                    Button(action: removeArticlesFromPlan) {
                        Text("Remove Articles")
                    }
                    .gridColumnAlignment(.leading)
            }
            .padding(.leading)
            Divider()
                .padding(.vertical, 4)
            GridRow(alignment: .firstTextBaseline) {
                    Text("User data:")
                    .gridColumnAlignment(.trailing)
                    Button {
                        isShowingDeletionDialog = true
                    } label: {
                        Text("Remove All")
                    }
                    .gridColumnAlignment(.leading)
            }
            .padding(.leading)
            GridRow {
                Text("")
                Text("Removes bookmarks, highlights, and progress. Removes articles from training plan.")
                    .font(design.subtextFont)
                    .foregroundStyle(design.subtextStyle)
                    .gridColumnAlignment(.leading)
            }
            .padding(.leading)
            Divider()
                .padding(.vertical, 4)
            Group {
                GridRow(alignment: .firstTextBaseline) {
                    Text("Tips:")
                        .gridColumnAlignment(.trailing)
                    Button(action: resetTips) {
                        Text("Reset")
                    }
                    .gridColumnAlignment(.leading)
                }
                .padding(.leading)
                GridRow {
                    Text("")
                    Text("Resets tips the next time you launch the app.")
                        .font(design.subtextFont)
                        .foregroundStyle(design.subtextStyle)
                        .gridColumnAlignment(.leading)
                }
                .padding(.leading)
            }
            .disabled(shouldResetTips)
        }
        .padding()
        .fixedSize(horizontal: true, vertical: true)
        .confirmationDialog(dialogTitle, isPresented: $isShowingDeletionDialog) {
            Button(role: .destructive, action: deleteUserData) {
                Text("Remove Now")
            }
        } message: {
            Text("You can't undo this action.")
        }
    }
    
    @AppStorage(Self.shouldResetTipsKey, store: UserDefaults(suiteName: "ArticleAcceleratorGroup")) private var shouldResetTips = false
    @Environment(\.modelContext) private var context
    @State private var isShowingDeletionDialog = false
    @State private var showErrorDialog = false
    
    private var dialogTitle: String {
        "Are you sure you want to remove all user data and restore the app to its default state?"
    }
    
    private func deleteUserData() {
        do {
            try context.delete(model: ArticleState.self)
            try context.delete(model: TrainingPlanItem.self)
        } catch {
            fatalError("Error deleting user data. Application has stopped.")
        }
    }
    
    private func removeArticlesFromPlan() {
        do {
            try context.delete(model: TrainingPlanItem.self)
            WidgetCenter.shared.reloadAllTimelines()
        } catch {
            fatalError("Error removing articles from training plan. Application has stopped.")
        }
    }
    
    private func resetTips() {
        shouldResetTips = true
    }
}

fileprivate typealias design = Design.Settings
