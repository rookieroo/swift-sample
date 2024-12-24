/*
 See LICENSE folder for this sample’s licensing information.
 */

import SwiftUI

struct CardViewWrapper: NSViewRepresentable {
    typealias Coordinator = PickDelegate
    
    @Binding var chosenNumbers: Set<Int>
    @Binding var skippedNumbers: Set<Int>
    
    let color: Color
    
    func makeCoordinator() -> Coordinator {
        Coordinator(picked: $chosenNumbers, skipped: $skippedNumbers)
    }
    
    func makeNSView(context: Context) -> CardView {
        let cardView = CardView(frame: .zero)
        cardView.delegate = context.coordinator
        return cardView
    }
    
    func updateNSView(_ cardView: CardView, context: Context) {
        cardView.fillColor = NSColor(color)
        cardView.excludeNumbers = chosenNumbers.union(skippedNumbers).sorted()
    }
    
    class PickDelegate: NSObject, CardViewDelegate {
        @Binding var picked: Set<Int>
        @Binding var skipped: Set<Int>
        
        init(picked: Binding<Set<Int>>, skipped: Binding<Set<Int>>) {
            _picked = picked
            _skipped = skipped
        }
        
        func cardView(_ cardView: CardView, didPick number: Int) {
            picked.insert(number)
        }
        
        func cardView(_ cardView: CardView, didSkip number: Int) {
            skipped.insert(number)
        }
    }
}

#Preview {
    CardViewWrapper(chosenNumbers: .constant([]), skippedNumbers: .constant([]), color: .green)
}
