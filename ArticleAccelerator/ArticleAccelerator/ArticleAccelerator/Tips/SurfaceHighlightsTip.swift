// See LICENSE folder for this sample’s licensing information.

import TipKit

struct SurfaceHighlightsTip: Tip {
    static let didAddHighlight: Event = Event(id: "didAddHighlight")
    static let didViewArticle: Event = Event(id: "didViewArticle")

    var title: Text {
        Text("Highlight Text")
    }
    var message: Text? {
        Text("Select text in an article, Control-click, and choose your highighter color.")
    }
    var image: Image? {
        Image(systemName: "highlighter")
    }
    var rules: [Rule] {
        [
            #Rule(Self.didAddHighlight) {
                $0.donations.count < 1
            },
            #Rule(Self.didViewArticle) {
                $0.donations.count > 2
            }
        ]
    }
    var actions: [Action] {
        [
            Action(id: "tryIt", title: "Try It"),
            Action(id: "done", title: "Done")
        ]
    }
}
