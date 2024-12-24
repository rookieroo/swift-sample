// See LICENSE folder for this sample’s licensing information.

import TipKit

struct SurfaceHighlightsInspectorTip: Tip {
    static let didAddHighlight: Event = Event(id: "didAddHighlight")

    var title: Text {
        Text("View Highlights & Notes")
    }
    var message: Text? {
        Text("Your highlights appear here, where you can change, delete, or annotate them.")
    }
    var image: Image? {
        Image(systemName: "sidebar.right")
    }
    var rules: [Rule] {
        [
            #Rule(Self.didAddHighlight) {
                $0.donations.count > 4
            }
        ]
    }
}
