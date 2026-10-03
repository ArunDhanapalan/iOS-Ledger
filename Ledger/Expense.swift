import SwiftUI

// MARK: - Category Enum
enum Category: String, CaseIterable, Codable, Identifiable {
    case food = "Food"
    case travel = "Travel"
    case shopping = "Shopping"
    case bills = "Bills"
    case other = "Other"
    
    var id: String { rawValue }
    
    var icon: String {
        switch self {
        case .food: return "fork.knife"
        case .travel: return "airplane"
        case .shopping: return "cart.fill"
        case .bills: return "doc.text.fill"
        case .other: return "ellipsis.circle.fill"
        }
    }
    
    var color: Color {
        switch self {
        case .food: return .orange
        case .travel: return .blue
        case .shopping: return .purple
        case .bills: return .red
        case .other: return .gray
        }
    }
}

// MARK: - Expense Data Model
struct Expense: Identifiable, Codable {
    var id = UUID()
    var title: String
    var amount: Double
    var category: Category
    var date: Date
    
    var formattedAmount: String {
        String(format: "$%.2f", amount)
    }
    
    var formattedDate: String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        return formatter.string(from: date)
    }
}
