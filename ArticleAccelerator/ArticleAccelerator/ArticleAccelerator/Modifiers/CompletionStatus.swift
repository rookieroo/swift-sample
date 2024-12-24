// See LICENSE folder for this sample’s licensing information.

import SwiftUI

struct CompletionStatus: ViewModifier {
    let status: Bool
    let layoutStyle: CollectionLayoutStyle
    
    func body(content: Content) -> some View {
        ZStack(alignment: .bottomTrailing) {
            if status {
                content
                    .blur(radius: design.blurRadius, opaque: true)
                    .overlay(design.overlayBackgroundColor.opacity(design.darkenFactor))
                    .overlay(alignment: .bottomTrailing) {
                        Image(systemName: "checkmark.circle.fill")
                            .foregroundStyle(design.symbolStyle)
                            .font(layoutStyle == .grid ? design.gridSymbolFont : design.listSymbolFont)
                            .padding(design.symbolPadding)
                    }
            } else {
                content
            }
        }
    }
}

extension View {
    func completionStatus(_ status: Bool, layoutStyle: CollectionLayoutStyle = .grid) -> some View {
        modifier(CompletionStatus(status: status, layoutStyle: layoutStyle))
    }
}

fileprivate typealias design = Design.CompletionStatus
