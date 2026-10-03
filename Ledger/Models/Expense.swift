import Foundation

struct Expense: Identifiable, Codable, Equatable {
    var id: UUID = UUID()
    var title: String
    var amount: Double
    var category: Category
    var date: Date
    var note: String?
    
    /// Formatted currency string (e.g. "$24.50")
    var formattedAmount: String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.locale = Locale.current
        return formatter.string(from: NSNumber(value: amount)) ?? String(format: "$%.2f", amount)
    }
    
    /// User-friendly formatted date (e.g. "Oct 3, 2026")
    var formattedDate: String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .none
        return formatter.string(from: date)
    }
    
    /// Date with time for detail view (e.g. "Oct 3, 2026 at 2:30 PM")
    var formattedFullDate: String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        return formatter.string(from: date)
    }
}
