// See LICENSE folder for this sample’s licensing information.

import Foundation

enum Period: Int, CaseIterable, Identifiable {
    case week
    case month
    case year
    
    var dateRange: ClosedRange<Date> {
        switch self {
        case .week:
            return Self.week.sentinelDate...Date.now
        case .month:
            return Self.month.sentinelDate...Self.week.sentinelDate
        case .year:
            return Self.year.sentinelDate...Self.month.sentinelDate
        }
    }
    var displayName: String {
        switch self {
        case .week: return "This Week"
        case .month: return "This Month"
        case .year: return "This Year"
        }
    }
    var id: Int { rawValue }
    
    private var sentinelDate: Date {
        let component: Calendar.Component
        switch self {
        case .week: component = .weekOfYear
        case .month: component = .month
        case .year: component = .year
        }
        guard let sentinelDate = Locale.current.calendar.date(byAdding: component, value: -1, to: Date.now) else {
            fatalError("Date can't be calculated using given input or is out of range for the current calendar.")
        }
        return sentinelDate
    }
}
