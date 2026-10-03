import Foundation
import Combine

class ExpenseStore: ObservableObject {
    @Published var expenses: [Expense] = [] {
        didSet {
            saveExpenses()
        }
    }
    
    private let storageKey = "SavedExpenses_v1"
    
    init() {
        loadExpenses()
    }
    
    // MARK: - Persistence (UserDefaults + JSON)
    
    private func saveExpenses() {
        do {
            let encoded = try JSONEncoder().encode(expenses)
            UserDefaults.standard.set(encoded, forKey: storageKey)
        } catch {
            print("Failed to save expenses: \(error.localizedDescription)")
        }
    }
    
    private func loadExpenses() {
        guard let data = UserDefaults.standard.data(forKey: storageKey),
              let decoded = try? JSONDecoder().decode([Expense].self, from: data) else {
            // Load initial mock data for first-time launch / lab demo
            loadSampleData()
            return
        }
        self.expenses = decoded
    }
    
    // MARK: - CRUD Actions
    
    func addExpense(title: String, amount: Double, category: Category, date: Date, note: String?) {
        let trimmedTitle = title.trimmingCharacters(in: .whitespacesAndNewlines)
        let trimmedNote = note?.trimmingCharacters(in: .whitespacesAndNewlines)
        
        let newExpense = Expense(
            title: trimmedTitle.isEmpty ? "Expense" : trimmedTitle,
            amount: amount,
            category: category,
            date: date,
            note: trimmedNote?.isEmpty == false ? trimmedNote : nil
        )
        expenses.insert(newExpense, at: 0)
    }
    
    func deleteExpense(at offsets: IndexSet) {
        expenses.remove(atOffsets: offsets)
    }
    
    func deleteExpense(id: UUID) {
        expenses.removeAll { $0.id == id }
    }
    
    // MARK: - Analytics & Computations
    
    /// Total spending across all recorded expenses
    var totalSpending: Double {
        expenses.reduce(0) { $0 + $1.amount }
    }
    
    /// Spending for the current calendar month
    var currentMonthSpending: Double {
        let calendar = Calendar.current
        let currentYear = calendar.component(.year, from: Date())
        let currentMonth = calendar.component(.month, from: Date())
        
        return expenses.filter { expense in
            let expYear = calendar.component(.year, from: expense.date)
            let expMonth = calendar.component(.month, from: expense.date)
            return expYear == currentYear && expMonth == currentMonth
        }.reduce(0) { $0 + $1.amount }
    }
    
    /// Total amount spent in a specific category
    func spending(for category: Category) -> Double {
        expenses
            .filter { $0.category == category }
            .reduce(0) { $0 + $1.amount }
    }
    
    /// Percentage (0.0 to 1.0) of total spending for a category
    func spendingPercentage(for category: Category) -> Double {
        guard totalSpending > 0 else { return 0.0 }
        return spending(for: category) / totalSpending
    }
    
    /// Number of transactions for a specific category
    func count(for category: Category) -> Int {
        expenses.filter { $0.category == category }.count
    }
    
    /// Most recent expenses sorted by date descending
    func recentExpenses(limit: Int = 5) -> [Expense] {
        Array(expenses.sorted(by: { $0.date > $1.date }).prefix(limit))
    }
    
    // MARK: - Seed Data for First Launch
    
    private func loadSampleData() {
        let calendar = Calendar.current
        let today = Date()
        
        expenses = [
            Expense(
                title: "Groceries & Supermarket",
                amount: 64.20,
                category: .food,
                date: today,
                note: "Weekly fruits, vegetables, and milk"
            ),
            Expense(
                title: "Campus Metro Pass",
                amount: 30.00,
                category: .travel,
                date: calendar.date(byAdding: .day, value: -1, to: today) ?? today,
                note: "Monthly student transit pass"
            ),
            Expense(
                title: "Textbook - Data Structures",
                amount: 85.50,
                category: .education,
                date: calendar.date(byAdding: .day, value: -2, to: today) ?? today,
                note: "Purchased from university bookstore"
            ),
            Expense(
                title: "Movie Tickets & Snacks",
                amount: 22.00,
                category: .entertainment,
                date: calendar.date(byAdding: .day, value: -3, to: today) ?? today,
                note: "Weekend movie with friends"
            ),
            Expense(
                title: "Internet Fiber Bill",
                amount: 45.00,
                category: .bills,
                date: calendar.date(byAdding: .day, value: -5, to: today) ?? today,
                note: "Home high-speed broadband"
            ),
            Expense(
                title: "Wireless Earbuds",
                amount: 49.99,
                category: .shopping,
                date: calendar.date(byAdding: .day, value: -7, to: today) ?? today,
                note: "Replacement for lost pair"
            )
        ]
    }
}
