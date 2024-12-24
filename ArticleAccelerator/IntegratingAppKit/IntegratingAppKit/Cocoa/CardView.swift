/*
 See LICENSE folder for this sample’s licensing information.
 */

import Cocoa

class CardView: NSView {
    var fillColor: NSColor?
    var number: Int = shuffle()
    var excludeNumbers: [Int]?
    weak var delegate: CardViewDelegate?
    
    private var pickBox: NSRect?

    override func draw(_ dirtyRect: NSRect) {
        NSGraphicsContext.saveGraphicsState()
        fillColor?.setFill()
        let path = NSBezierPath(roundedRect: bounds, xRadius: 8, yRadius: 8)
        path.setClip()
        path.fill()
        path.lineWidth = 6
        path.stroke()
        pickBox = number.drawCentered(in: bounds)
        NSGraphicsContext.restoreGraphicsState()
    }
    
    override func mouseUp(with event: NSEvent) {
        guard (excludeNumbers?.count ?? 0) < 99 else { return }
        if event.modifierFlags.contains(.option) {
            skip()
        } else {
            pick()
        }
    }
    
    private func skip() {
        let skippedNumber = number
        shuffle()
        delegate?.cardView(self, didSkip: skippedNumber)
    }
    
    private func pick() {
        delegate?.cardView(self, didPick: number)
        shuffle()
    }
    
    private func shuffle() {
        number = Self.shuffle(excluding: excludeNumbers ?? [])
        needsDisplay = true
    }
    
    private static func shuffle(excluding numbers: [Int] = []) -> Int {
        var number = Int.random(in: 1..<100)
        while numbers.contains(number), numbers.count < 99 {
            number = Int.random(in: 1..<100)
        }
        return number
    }
}

protocol CardViewDelegate: AnyObject {
    func cardView(_ cardView: CardView, didPick number: Int)
    func cardView(_ cardView: CardView, didSkip number: Int)
}

fileprivate extension NSRect {
    var center: NSPoint { NSPoint(x: midX, y: midY) }
}

fileprivate extension Int {
    @discardableResult
    func drawCentered(in bounds: NSRect) -> NSRect {
        let text = NSString(format: "%i", self)
        let attributes = [
            NSAttributedString.Key.font : NSFont.preferredFont(forTextStyle: .largeTitle)
        ]
        let size = text.size(withAttributes: attributes)
        let center = bounds.center
        let origin = NSPoint(x: center.x - 0.5 * size.width, y: center.y - 0.5 * size.height)
        let backgroundSize = NSSize(width: size.width + 8, height: size.height + 6)
        let backgroundOrigin = NSPoint(x: origin.x - 4, y: origin.y - 3)
        NSColor.white.withAlphaComponent(0.6).setFill()
        let backgroundBounds = NSRect(origin: backgroundOrigin, size: backgroundSize)
        NSBezierPath(roundedRect: backgroundBounds, xRadius: 4, yRadius: 4).fill()
        NSColor.black.setStroke()
        text.draw(at: origin, withAttributes: attributes)
        return backgroundBounds
    }
}
