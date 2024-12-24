/*
 See LICENSE folder for this sample’s licensing information.
 */

import SwiftUI

struct GradientViewWrapper: NSViewRepresentable {
    let colors: [Color]
    
    func makeNSView(context: Context) -> GradientView {
        return GradientView(frame: .zero)
    }
    
    func updateNSView(_ colorGradientView: GradientView, context: Context) {
        colorGradientView.colors = colors.map { NSColor($0) }
    }
}

#Preview {
    GradientViewWrapper(colors: [.green, .red, .cyan])
}
