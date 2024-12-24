// See LICENSE folder for this sample’s licensing information.

import ArticleStore
import Quartz
import SwiftUI

struct ThreeDView: NSViewRepresentable {
    let media: Media
    
    func makeNSView(context: Context) -> NSView {
        guard let previewView = QLPreviewView(frame: .zero, style: .normal) else {
            fatalError("Error creating view from AppKit")
        }
        previewView.previewItem = media.path.original as NSURL
        previewView.autostarts = true
        return previewView
    }
    
    func updateNSView(_ nsView: NSView, context: Context) { }
}

#Preview {
    ThreeDView(media: .sample)
}

#Preview {
    ThreeDView(media: .sampleVideo)
}
