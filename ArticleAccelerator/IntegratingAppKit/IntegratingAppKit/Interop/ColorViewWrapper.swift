/*
 See LICENSE folder for this sample’s licensing information.
 */

import SwiftUI

struct ColorViewWrapper: NSViewRepresentable {
    @State private var color: Color = .green
    
    func makeNSView(context: Context) -> ColorView {
        return ColorView(frame: .zero)
    }
    
    func updateNSView(_ colorView: ColorView, context: Context) {
        colorView.fillColor = NSColor(color)
    }
}

#Preview(body: {
    ColorViewWrapper()
})
