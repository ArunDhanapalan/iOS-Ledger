import SwiftUI

enum Category: String, CaseIterable, Codable, Identifiable {
    case food = "Food"
    case travel = "Travel"
    case shopping = "Shopping"
    case education = "Education"
    case bills = "Bills"
    case entertainment = "Entertainment"
    case other = "Other"
    
    var id: String { rawValue }
    
    /// SF Symbol icon representing each category
    var iconName: String {
        switch self {
        case .food: return "fork.knife"
        case .travel: return "airplane"
        case .shopping: return "cart.fill"
        case .education: return "book.fill"
        case .bills: return "doc.text.fill"
        case .entertainment: return "tv.fill"
        case .other: return "ellipsis.circle.fill"
        }
    }
    
    /// Color associated with each category for charts and badges
    var color: Color {
        switch self {
        case .food: return Color.orange
        case .travel: return Color.blue
        case .shopping: return Color.purple
        case .education: return Color.green
        case .bills: return Color.red
        case .entertainment: return Color.pink
        case .other: return Color.gray
        }
    }
}
