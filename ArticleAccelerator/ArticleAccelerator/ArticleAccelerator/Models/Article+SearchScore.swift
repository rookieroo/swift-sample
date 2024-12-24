// See LICENSE folder for this sample’s licensing information.

import ArticleStore
import Foundation

extension Article {
    func searchScore(_ search: String) -> Int {
        let heroTitleScore = 1000
        let sectionTitleScore = 100
        let heroBodyScore = 10
        let sectionBodyScore = 1
        var score = 0

        if hero.header.localizedCaseInsensitiveContains(search) {
            score += heroTitleScore
        }
        if hero.content.localizedCaseInsensitiveContains(search) {
            score += heroBodyScore
        }
        for section in body {
            if section.header.localizedCaseInsensitiveContains(search) {
                score += sectionTitleScore
            }
            if section.content.localizedCaseInsensitiveContains(search) {
                score += sectionBodyScore
            }
        }
        
        return score
    }
}
