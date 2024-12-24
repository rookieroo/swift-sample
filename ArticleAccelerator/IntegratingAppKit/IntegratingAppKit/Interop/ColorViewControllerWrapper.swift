/*
 See LICENSE folder for this sample’s licensing information.
 */

import SwiftUI

struct ColorViewControllerWrapper: NSViewControllerRepresentable {
    @Binding var color1: Color
    @Binding var color2: Color
    @Binding var color3: Color
    
    func makeNSViewController(context: Context) -> ColorViewController {
        return ColorViewController()
    }
    
    func updateNSViewController(_ colorViewController: ColorViewController, context: Context) {
        colorViewController.view1.fillColor = NSColor(color1)
        colorViewController.view2.fillColor = NSColor(color2)
        colorViewController.view3.fillColor = NSColor(color3)
    }
}

#Preview(body: {
    ColorViewControllerWrapper(color1: .constant(.red), color2: .constant(.green), color3: .constant(.blue))
})
