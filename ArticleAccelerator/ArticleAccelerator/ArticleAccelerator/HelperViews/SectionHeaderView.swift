// See LICENSE folder for this sample’s licensing information.

import SwiftUI

struct SectionHeaderView: View {
    let name: String
    
    var body: some View {
        HStack {
            Text(name)
            Spacer()
        }
        .padding()
        .background(design.sectionHeaderMaterial)
        .padding(.bottom, design.bottomSpacing)
    }
}

#Preview {
    SectionHeaderView(name: "Preview")
}

fileprivate typealias design = Design.Detail
