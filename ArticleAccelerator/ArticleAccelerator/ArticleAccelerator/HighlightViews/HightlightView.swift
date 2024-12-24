// See LICENSE folder for this sample’s licensing information.

import SwiftUI

struct HighlightView: View {
    @Bindable var highlight: Highlight
    let content: NSAttributedString
    let onDelete: () -> Void
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                Spacer()
                Button(action: editing ? remove : edit) {
                    Image(systemName: editing ? "trash.fill" : "pencil.circle.fill")
                }
                .tint(.secondary)
            }
            .buttonStyle(.borderless)
            .font(design.titleFont)
            .padding(.vertical, design.verticalPadding)
            Text(text)
                .lineLimit(design.textLineLimit)
                .foregroundStyle(design.textStyle)
                .fixedSize(horizontal: false, vertical: true)
                .padding(design.textInsetPadding)
                .padding(.leading, design.leadingPadding)
                .background(
                    textBackground()
                )
            if shouldShowNote {
                Text(highlight.note)
                    .padding(.top, design.Note.topPadding)
            }
            if editing {
                editingView()
            }
        }
        .padding()
        .background(isHovering ? SwiftUI.Color(nsColor: highlight.backgroundColor.withAlphaComponent(design.tintAlpha)) : SwiftUI.Color.clear)
        .onHover {
            isHovering = $0
        }
        .swipeActions(edge: .trailing) {
            Button("Remove", role: .destructive, action: remove)
        }
    }
    
    @State private var isHovering: Bool = false
    @State private var editing: Bool = false
    
    private var shouldShowNote: Bool {
        let hasNote = !highlight.note.isEmpty
        return hasNote && !editing
    }
    private var text: String {
        content.attributedSubstring(from: highlight.nsRange).string
    }
    
    // MARK: - helper views
    
    @ViewBuilder
    private func editingView() -> some View {
        TextEditor(text: $highlight.note)
            .font(design.Note.textFont)
            .frame(minHeight: design.Note.editorMinimumHeight)
            .fixedSize(horizontal: false, vertical: true)
            .scrollDisabled(true)
        HStack {
            Menu(highlight.style.title) {
                Picker("", selection: $highlight.style) {
                    ForEach(Highlight.Style.allCases) { style in
                        Image(systemName: style == highlight.style ? "circle.fill" : "circle")
                            .tint(SwiftUI.Color(nsColor: style.background))
                            .tag(style)
                    }
                }
                .pickerStyle(.palette)
                .paletteSelectionEffect(.custom)
            }
            Circle()
                .fill(SwiftUI.Color(nsColor: highlight.style.background))
                .frame(width: design.colorIndicatorDiameter)
            Button("OK") {
                editing = false
            }
            .buttonStyle(.bordered)
        }
        .fixedSize(horizontal: false, vertical: true)
    }
    
    fileprivate func textBackground() -> some View {
        ZStack {
            SwiftUI.Color(nsColor: highlight.backgroundColor.withAlphaComponent(design.tintAlpha))
                .cornerRadius(design.backgroundCornerRadius)
            HStack {
                Capsule()
                    .fill(SwiftUI.Color(nsColor: highlight.style.background))
                    .frame(width: design.capsuleWidth)
                Spacer()
            }
            .padding(design.textInsetPadding)
        }
    }
    
    // MARK: - helper functions
    
    private func edit() {
        editing = true
    }
    
    private func remove() {
        onDelete()
    }
}

fileprivate typealias design = Design.Article.Highlight
