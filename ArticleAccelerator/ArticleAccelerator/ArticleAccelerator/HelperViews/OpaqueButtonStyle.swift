// See LICENSE folder for this sample’s licensing information.

import SwiftUI

struct OpaqueButtonStyle: ButtonStyle {
    public func makeBody(configuration: OpaqueButtonStyle.Configuration) -> some View {
        configuration.label
            .opacity(configuration.isPressed ? 1 : 1)
    }
}
