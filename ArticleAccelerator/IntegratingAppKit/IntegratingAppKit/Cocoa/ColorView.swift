/*
 See LICENSE folder for this sample’s licensing information.
 */

import Cocoa

class ColorView: NSView {
    var fillColor: NSColor?
    
    override func draw(_ dirtyRect: NSRect) {
        super.draw(dirtyRect)
        
        NSGraphicsContext.saveGraphicsState()
        fillColor?.setFill()
        let path = NSBezierPath(roundedRect: bounds, xRadius: 8, yRadius: 8)
        path.setClip()
        path.lineWidth = 6
        path.fill()
        path.stroke()
        NSGraphicsContext.restoreGraphicsState()
    }
}
