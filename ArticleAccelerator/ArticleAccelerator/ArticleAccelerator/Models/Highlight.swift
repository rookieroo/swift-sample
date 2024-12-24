// See LICENSE folder for this sample’s licensing information.

import Cocoa
import SwiftData
import SwiftUI

@Model
class Highlight: Identifiable {
    let id: UUID
    var style: Style
    var note: String
    var backgroundColor: NSColor { style.background }
    var foregroundColor: NSColor { style.foreground }
    let range: Range<Int>
    
    var nsRange: NSRange {
        NSRange(location: range.lowerBound, length: range.upperBound - range.lowerBound)
    }
    
    weak var articleState: ArticleState?
    
    init(id: UUID, range: Range<Int>, style: Style, note: String = "") {
        self.id = id
        self.range = range
        self.style = style
        self.note = note
    }
}

extension Highlight {
    enum Style: Int, CaseIterable, Codable, Identifiable {
        case yellow
        case red
        case orange
        case blue
        case green
        case purple
        
        var background: NSColor {
            switch self {
            case .yellow: return NSColor(named: "highlightYellow")!
            case .red: return NSColor(named: "highlightRed")!
            case .orange: return NSColor(named: "highlightOrange")!
            case .blue: return NSColor(named: "highlightBlue")!
            case .green: return NSColor(named: "highlightGreen")!
            case .purple: return NSColor(named: "highlightPurple")!
            }
        }
        var foreground: NSColor {
            switch self {
            case .yellow: return .labelColor
            case .red: return .labelColor
            case .orange: return .labelColor
            case .blue: return .labelColor
            case .green: return .labelColor
            case .purple: return .labelColor
            }
        }
        var id: Int { rawValue }
    }
}

extension Highlight {
    func applyRandomStyle() {
        var newStyleValue = Int.random(in: Style.allCases.indices)
        while newStyleValue == self.style.rawValue {
            newStyleValue = Int.random(in: Style.allCases.indices)
        }
        guard let randomStyle = Style(rawValue: newStyleValue) else { return }
        self.style = randomStyle
    }
}

