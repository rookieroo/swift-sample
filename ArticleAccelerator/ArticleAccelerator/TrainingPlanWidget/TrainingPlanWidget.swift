// See LICENSE folder for this sample’s licensing information.

import ArticleStore
import SwiftData
import SwiftUI
import WidgetKit

struct TrainingPlanWidget: Widget {
    let kind: String = "TrainingPlanWidget"
    
    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: Provider()) { entry in
            if #available(macOS 14.0, *) {
                TrainingPlanWidgetEntryView(entry: entry)
                    .modelContainer(for: [TrainingPlanItem.self, ArticleState.self])
                    .containerBackground(design.background, for: .widget)
            } else {
                TrainingPlanWidgetEntryView(entry: entry)
                    .modelContainer(for: [TrainingPlanItem.self, ArticleState.self])
                    .padding()
                    .background()
            }
        }
        .configurationDisplayName("Article Accelerator Training Plan")
        .description("Launch Article Accelerator.")
    }
}

struct TrainingPlanEntry: TimelineEntry {
    let date: Date
}

struct Provider: TimelineProvider {
    let modelContext = try? ModelContext(ModelContainer(for: TrainingPlanItem.self, ArticleState.self))
    
    func getSnapshot(in context: Context, completion: @escaping (TrainingPlanEntry) -> ()) {
        let entry = TrainingPlanEntry(date: Date())
        completion(entry)
    }
    
    func getTimeline(in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        let entry = TrainingPlanEntry(date: Date())
        let timeline = Timeline(entries: [entry], policy: .atEnd)
        completion(timeline)
    }
    
    func placeholder(in context: Context) -> TrainingPlanEntry {
        return TrainingPlanEntry(date: Date())
    }
}

fileprivate typealias design = Design.TrainingPlan.Widget
