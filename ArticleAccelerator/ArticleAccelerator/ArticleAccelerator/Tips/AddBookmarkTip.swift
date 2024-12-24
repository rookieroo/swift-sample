// See LICENSE folder for this sample’s licensing information.

import TipKit

struct AddBookmarkTip: Tip {
    static let didViewArticle: Event = Event(id: "didViewArticle")

    var title: Text {
        Text("Bookmark an Article")
    }
    var message: Text? {
        Text("Your bookmarked articles appear in My Stuff.")
    }
    // This tip doesn't include an image definition, because the popover points to an image.
    
    var rules: [Rule] {
        [
            #Rule(Self.didViewArticle) {
                $0.donations.count == 5
            }
        ]
    }
}
