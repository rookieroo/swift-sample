/*
 See LICENSE folder for this sample’s licensing information.
 */

import Cocoa

class GradientView: NSView {
    var colors: [NSColor]?
    
    private var gradient: NSGradient? { NSGradient(colors: colors ?? [.red, .green]) }
    
    override func draw(_ dirtyRect: NSRect) {
        super.draw(dirtyRect)
        
        NSGraphicsContext.saveGraphicsState()
        let path = NSBezierPath(roundedRect: bounds, xRadius: 8, yRadius: 8)
        path.setClip()
        gradient?.draw(in: bounds, angle: 25)
        path.lineWidth = 6
        path.stroke()
        NSGraphicsContext.restoreGraphicsState()
    }
}
