// See LICENSE folder for this sample’s licensing information.

import Foundation

extension CollectionLayoutStyle {
    static func presentation(for menuCommands: [ArticleCommands.ToggleState]) -> CollectionLayoutStyle {
        for toggleState in (menuCommands.filter { $0.isOn }) {
            for style in Self.allCases {
                if toggleState.menuCommand == style.displayName {
                    return style
                }
            }
        }
        return .grid
    }
    
    static func togglesForPresentationStyles() -> [ArticleCommands.ToggleState] {
        var togglesForPresentationStyles = [ArticleCommands.ToggleState]()
        for style in Self.allCases {
            var toggleState: ArticleCommands.ToggleState
            switch style {
            case .grid:
                toggleState = ArticleCommands.ToggleState(menuCommand: style.displayName, isOn: true, shortcut: .init("g"))
            case .list:
                toggleState = ArticleCommands.ToggleState(menuCommand: style.displayName, isOn: false, shortcut: .init("l"))
            }
            togglesForPresentationStyles.append(toggleState)
        }
        return togglesForPresentationStyles
    }
}
