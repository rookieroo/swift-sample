// See LICENSE folder for this sample’s licensing information.

import SwiftUI

struct SearchField: View {
    @Binding var search: String
    
    var body: some View {
        HStack {
            Image(systemName: "magnifyingglass")
            TextField("", text: $search)
                .textFieldStyle(design.textStyle)
        }
        .padding(.horizontal, design.horizontalSpacing)
        .padding(.vertical, design.verticalSpacing)
        .background {
            RoundedRectangle(cornerRadius: design.cornerRadius)
                .stroke(design.strokeColor, lineWidth: design.strokeWidth)
        }
        .frame(width: design.width)
    }
}

fileprivate typealias design = Design.Search
