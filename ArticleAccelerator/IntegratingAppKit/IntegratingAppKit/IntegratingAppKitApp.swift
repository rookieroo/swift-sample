/*
 See LICENSE folder for this sample’s licensing information.
 */

import SwiftUI

@main
struct IntegratingAppKitApp: App {
    var body: some Scene {
        WindowGroup {
            VStack {
                NumberPickerView()
                Divider()
                    .padding(.horizontal)
                MultiColorView()
            }
        }
    }
}
