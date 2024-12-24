// See LICENSE folder for this sample’s licensing information.

import ArticleStore
import SwiftData

@Model
final class TrainingPlanItem {
    let articleID: String
    var index: Int
    
    init(articleID: String, index: Int) {
        self.articleID = articleID
        self.index = index
    }
}
