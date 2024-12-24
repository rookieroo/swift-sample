// See LICENSE folder for this sample’s licensing information.

import Foundation

enum SidebarSelection: Int, CaseIterable, Identifiable {
    case featured
    case myStuff
    case recentlyAdded
    case browseAll
    
    var allowsList: Bool {
        self != .featured
    }
    var displayImageName: String {
        switch self {
            case .featured:
                return "star"
            case .browseAll:
                return "rectangle.on.rectangle"
            case .myStuff:
                return "person.crop.square"
            case .recentlyAdded:
                return "clock"
        }
    }
    var displayName: String {
        switch self {
            case .featured:
                return "Featured"
            case .browseAll:
                return "Browse All"
            case .myStuff:
                return "My Stuff"
            case .recentlyAdded:
                return "Recently Added"
        }
    }
    var id: Int { rawValue }
}
