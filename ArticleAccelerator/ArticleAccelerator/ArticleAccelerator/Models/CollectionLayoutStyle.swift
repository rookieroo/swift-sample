// See LICENSE folder for this sample’s licensing information.

import Foundation

enum CollectionLayoutStyle: Int, CaseIterable, Identifiable {
    case grid
    case list
    
    var displayImageName: String {
        switch self {
        case .grid: return "square.grid.2x2"
        case .list: return "list.bullet"
        }
    }
    var displayName: String {
        switch self {
        case .grid: return "as Grid"
        case .list: return "as List"
        }
    }
    var id: Int { rawValue }
    var toolTipName: String {
        switch self {
        case .grid: return "View as Grid"
        case .list: return "View as List"
        }
    }
}
