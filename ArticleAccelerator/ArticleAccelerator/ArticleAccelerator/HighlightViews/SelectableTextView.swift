// See LICENSE folder for this sample’s licensing information.

import Cocoa

class SelectableTextView: NSTextView {
    weak var styleDelegate: StyleDelegate?
    
    override func menu(for event: NSEvent) -> NSMenu? {
        guard let menu = super.menu(for: event) else {
            return nil
        }
        menu.removeAllItems()
        menu.allowsContextMenuPlugIns = false
        
        for style in Highlight.Style.allCases {
            let imageConfiguration = NSImage.SymbolConfiguration(hierarchicalColor: style.background)
            guard let image = NSImage(systemSymbolName: "circle.fill", accessibilityDescription: nil)?.withSymbolConfiguration(imageConfiguration) else {
                continue
            }
            
            let menuItem = NSMenuItem()
            menuItem.title = style.title
            menuItem.image = image
            menuItem.tag = style.rawValue
            menuItem.keyEquivalent = style.keyEquivalent
            menuItem.action = #selector(didChooseStyle(_ :))
            menu.addItem(menuItem)
        }
        
        return menu
    }
    
    @objc func didChooseStyle(_ sender: NSMenuItem) {
        let selectedRange = selectedRange()
        let range = Range<Int>(uncheckedBounds: (selectedRange.lowerBound, selectedRange.upperBound))
        if let style = Highlight.Style(rawValue: sender.tag) {
            styleDelegate?.selectableTextView(self, didChooseStyle: style, forRange: range)
        }
    }
    
    protocol StyleDelegate: NSObjectProtocol {
        func selectableTextView(_ selectableTextView: SelectableTextView, didChooseStyle: Highlight.Style, forRange: Range<Int>)
    }
}

extension Highlight.Style {
    var title: String {
        switch self {
        case .yellow: "Yellow"
        case .red: "Red"
        case .orange: "Orange"
        case .blue: "Blue"
        case .green: "Green"
        case .purple: "Purple"
        }
    }
    var keyEquivalent: String {
        switch self {
        case .yellow: "y"
        case .red: "r"
        case .orange: "o"
        case .blue: "b"
        case .green: "g"
        case .purple: "p"
        }
    }
}
