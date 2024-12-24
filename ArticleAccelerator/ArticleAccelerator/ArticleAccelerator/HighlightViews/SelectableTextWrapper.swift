// See LICENSE folder for this sample’s licensing information.

import SwiftUI
import ArticleStore

struct SelectableTextWrapper: NSViewRepresentable {
    let text: NSAttributedString
    @Binding var highlight: Highlight?
    
    func makeCoordinator() -> StyleCoordinator {
        StyleCoordinator(highlight: $highlight)
    }
    
    func makeNSView(context: Context) -> SelectableTextView {
        let textView = SelectableTextView(frame: .zero)
        textView.styleDelegate = context.coordinator
        textView.layoutManager?.allowsNonContiguousLayout = true
        textView.backgroundColor = .clear
        textView.isEditable = false
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.textStorage?.setAttributedString(text)
        textView.selectedTextAttributes = [
            NSAttributedString.Key.backgroundColor : design.Highlight.backgroundColor,
            NSAttributedString.Key.foregroundColor : design.Highlight.foregroundColor
        ]
        
        textView.heightAnchor.constraint(equalToConstant: height).isActive = true
        textView.widthAnchor.constraint(lessThanOrEqualToConstant: maxWidth).isActive = true
        
        return textView
    }
    
    func updateNSView(_ nsView: SelectableTextView, context: Context) {
        nsView.textStorage?.setAttributedString(text)
    }
    
    private var maxWidth: CGFloat { design.contentWidth }
    private var height: CGFloat {
        let maxWidthSize = NSSize(width: maxWidth, height: .greatestFiniteMagnitude)
        let bounds = text.boundingRect(with: maxWidthSize, options: .usesLineFragmentOrigin)
        return bounds.height
    }
    
    class StyleCoordinator: NSObject, SelectableTextView.StyleDelegate {
        @Binding var highlight: Highlight?
        
        init(highlight: Binding<Highlight?>) {
            _highlight = highlight
        }
        
        func selectableTextView(_ selectableTextView: SelectableTextView, didChooseStyle style: Highlight.Style, forRange range: Range<Int>) {
            highlight = Highlight(id: UUID(), range: range, style: style)
        }
    }
}

#Preview(body: {
    SelectableTextWrapper(text: NSAttributedString(string: "Phasellus congue vestibulum aliquet vitae vivamus. Mauris consectetur elit consequat bibendum tortor aliquam potenti odio et. Blandit integer maecenas felis dolor ornare. Sociosqu ridiculus elit sem ex lobortis eros dictumst montes gravida. Sollicitudin elementum consectetur luctus venenatis lorem diam nisi.\n\nMassa conubia consectetur hendrerit ligula duis at pellentesque. Proin auctor ornare consectetuer tempor ligula commodo maecenas tortor phasellus. Sem ante placerat ornare dictumst consectetuer nibh.  Placerat non quisque conubia fringilla ornare consequat habitasse. Ultricies platea diam dui sollicitudin nibh non augue accumsan himenaeos odio. Aenean convallis ex porta sagittis netus nostra justo interdum enim vulputate ad. Venenatis et cursus convallis donec tincidunt diam viverra sollicitudin ultrices.\n\nVulputate imperdiet inceptos sagittis adipiscing consequat mollis nostra enim natoque condimentum ipsum. Ut convallis sodales tellus primis consequat. Eleifend habitasse bibendum ac velit purus vestibulum natoque massa euismod. Facilisi id commodo class arcu etiam vulputate.  Nullam aenean integer congue adipiscing netus primis sapien. Nisi montes ipsum justo venenatis mattis curae lorem mollis erat.\n\nIn eget nostra pellentesque phasellus class malesuada torquent per adipiscing sollicitudin pharetra. Bibendum rutrum felis vivamus amet sem habitant molestie dui. Porttitor habitasse ullamcorper dignissim nullam sem."), highlight: .constant(nil))
        .padding()
})

fileprivate typealias design = Design.Article
