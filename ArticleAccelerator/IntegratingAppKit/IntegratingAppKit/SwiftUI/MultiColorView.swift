/*
 See LICENSE folder for this sample’s licensing information.
 */

import SwiftUI

struct MultiColorView: View {
    var body: some View {
        VStack(alignment: .leading) {
            Label("MultiColorView", systemImage: "testtube.2")
                .font(.title3)
            ZStack {
                GradientViewWrapper(colors: gradientColors)
                ColorViewControllerWrapper(color1: $color1, color2: $color2, color3: $color3)
                    .padding()
            }
            .frame(minHeight: 120)
        }
        .padding()
    }
    
    @State private var color1: Color = .leadingSolid
    @State private var color2: Color = .centerSolid
    @State private var color3: Color = .trailingSolid
    @State private var gradientColors: [Color] = [.gradientBegin, .gradientEnd]
}
#Preview {
    MultiColorView()
}
