/*
 See LICENSE folder for this sample’s licensing information.
 */

import Cocoa

class ColorViewController: NSViewController {
    var view1: ColorView!
    var view2: ColorView!
    var view3: ColorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view1 = ColorView(frame: .zero)
        view2 = ColorView(frame: .zero)
        view3 = ColorView(frame: .zero)
        
        let stackView = NSStackView(views: [view1, view2, view3])
        stackView.orientation = .horizontal
        stackView.distribution = .fillEqually
        stackView.spacing = 16
        view = stackView
    }
}
