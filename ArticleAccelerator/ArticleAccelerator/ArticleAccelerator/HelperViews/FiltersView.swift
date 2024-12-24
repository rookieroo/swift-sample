// See LICENSE folder for this sample’s licensing information.

import ArticleStore
import SwiftUI

struct FiltersView: View {
    @Binding var mediaFilter: MediaFilter
    @Binding var sortFilter: SortFilter
    
    var body: some View {
        HStack(alignment: .top) {
            Picker(selection: $mediaFilter) {
                ForEach(MediaFilter.allCases) { filter in
                    Text(filter.displayName)
                        .tag(filter)
                }
            } label: {
                Text("Media")
            }
            Picker(selection: $sortFilter) {
                ForEach(SortFilter.allCases) { filter in
                    Text(filter.displayName)
                        .tag(filter)
                }
            } label: {
                Text("Sort By")
            }
        }
    }
}

#Preview {
    FiltersView(mediaFilter: .constant(.any), sortFilter: .constant(.alphaIncreasing))
}

extension FiltersView {
    enum MediaFilter: Int, CaseIterable, Identifiable {
        case any
        case image
        case video
        case model
        
        var displayName: String {
            switch self {
            case .any: return "Any"
            case .image: return "Image"
            case .video: return "Video"
            case .model: return "3D Model"
            }
        }
        var id: Int { rawValue }
        
        func matches(_ media: Media) -> Bool {
            guard self != .any else { return true }
            switch media {
            case .image: return self == .image
            case .video: return self == .video
            case .threeD: return self == .model
            }
        }
    }
    
    enum SortFilter: Int, CaseIterable, Identifiable {
        case recentlyAdded
        case alphaIncreasing
        case alphaDecreasing
        
        var displayName: String {
            switch self {
            case .recentlyAdded: return "Recently Added"
            case .alphaIncreasing: return "Alphabetical (A-Z)"
            case .alphaDecreasing: return "Alphabetical (Z-A)"
            }
        }
        var id: Int { rawValue }
    }
}
