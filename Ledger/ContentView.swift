import SwiftUI
import Charts

// MARK: - Local Data Store & Persistence
class ExpenseDataStore: ObservableObject {
    @Published var expenses: [Expense] = [] {
        didSet { save() }
    }
    
    private let key = "SavedExpenses_v2"
    
    init() {
        if let data = UserDefaults.standard.data(forKey: key),
           let decoded = try? JSONDecoder().decode([Expense].self, from: data) {
            self.expenses = decoded
        } else {
            // Sample data for first launch
            self.expenses = [
                Expense(title: "Groceries", amount: 45.50, category: .food, date: Date()),
                Expense(title: "Bus Ticket", amount: 15.00, category: .travel, date: Date()),
                Expense(title: "New Shoes", amount: 65.00, category: .shopping, date: Date()),
                Expense(title: "Electricity Bill", amount: 50.00, category: .bills, date: Date())
            ]
        }
    }
    
    private func save() {
        if let encoded = try? JSONEncoder().encode(expenses) {
            UserDefaults.standard.set(encoded, forKey: key)
        }
    }
    
    var totalSpending: Double {
        expenses.reduce(0) { $0 + $1.amount }
    }
    
    func spending(for category: Category) -> Double {
        expenses.filter { $0.category == category }.reduce(0) { $0 + $1.amount }
    }
    
    func addExpense(title: String, amount: Double, category: Category, date: Date) {
        let newExpense = Expense(title: title.trimmingCharacters(in: .whitespaces), amount: amount, category: category, date: date)
        expenses.insert(newExpense, at: 0)
    }
    
    func deleteExpense(at offsets: IndexSet) {
        expenses.remove(atOffsets: offsets)
    }
}

// MARK: - Main Tab Container
struct ContentView: View {
    @StateObject private var store = ExpenseDataStore()
    @State private var selectedTab = 0
    
    var body: some View {
        TabView(selection: $selectedTab) {
            HomeView(store: store, selectedTab: $selectedTab)
                .tabItem { Label("Home", systemImage: "house.fill") }
                .tag(0)
            
            ExpenseListView(store: store)
                .tabItem { Label("Expenses", systemImage: "list.bullet") }
                .tag(1)
            
            AddExpenseView(store: store, selectedTab: $selectedTab)
                .tabItem { Label("Add Expense", systemImage: "plus.circle.fill") }
                .tag(2)
            
            CategoriesView(store: store)
                .tabItem { Label("Categories", systemImage: "chart.bar.fill") }
                .tag(3)
        }
    }
}

// MARK: - 1. Home View (Dashboard + Swift Charts Pie Chart)
struct HomeView: View {
    @ObservedObject var store: ExpenseDataStore
    @Binding var selectedTab: Int
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 20) {
                    // Total Spending Card
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Total Spending")
                            .font(.subheadline)
                            .foregroundColor(.white.opacity(0.8))
                        Text(String(format: "$%.2f", store.totalSpending))
                            .font(.system(size: 32, weight: .bold, design: .rounded))
                            .foregroundColor(.white)
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(20)
                    .background(LinearGradient(colors: [.blue, .indigo], startPoint: .topLeading, endPoint: .bottomTrailing))
                    .cornerRadius(16)
                    
                    // Swift Charts Pie / Donut Chart
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Category Breakdown")
                            .font(.headline)
                        
                        if store.totalSpending == 0 {
                            Text("No expenses recorded yet.")
                                .foregroundColor(.secondary)
                                .padding()
                        } else {
                            Chart(Category.allCases) { category in
                                let amount = store.spending(for: category)
                                if amount > 0 {
                                    SectorMark(
                                        angle: .value("Spending", amount),
                                        innerRadius: .ratio(0.6),
                                        angularInset: 1.5
                                    )
                                    .cornerRadii(4)
                                    .foregroundStyle(category.color)
                                }
                            }
                            .frame(height: 200)
                        }
                    }
                    .padding()
                    .background(Color(UIColor.secondarySystemGroupedBackground))
                    .cornerRadius(16)
                    
                    // Recent Expenses List Preview
                    VStack(alignment: .leading, spacing: 10) {
                        Text("Recent Expenses")
                            .font(.headline)
                        
                        ForEach(store.expenses.prefix(3)) { expense in
                            HStack {
                                Image(systemName: expense.category.icon)
                                    .foregroundColor(expense.category.color)
                                    .frame(width: 30)
                                VStack(alignment: .leading) {
                                    Text(expense.title).font(.body).fontWeight(.medium)
                                    Text(expense.formattedDate).font(.caption).foregroundColor(.secondary)
                                }
                                Spacer()
                                Text(expense.formattedAmount).font(.body).fontWeight(.semibold)
                            }
                            .padding(.vertical, 4)
                            Divider()
                        }
                    }
                    .padding()
                    .background(Color(UIColor.secondarySystemGroupedBackground))
                    .cornerRadius(16)
                }
                .padding()
            }
            .navigationTitle("Expense Tracker")
            .background(Color(UIColor.systemGroupedBackground).ignoresSafeArea())
        }
    }
}

// MARK: - 2. Expense List View
struct ExpenseListView: View {
    @ObservedObject var store: ExpenseDataStore
    
    var body: some View {
        NavigationView {
            List {
                ForEach(store.expenses) { expense in
                    HStack {
                        Image(systemName: expense.category.icon)
                            .foregroundColor(expense.category.color)
                            .frame(width: 32)
                        
                        VStack(alignment: .leading, spacing: 2) {
                            Text(expense.title)
                                .font(.body)
                                .fontWeight(.medium)
                            Text("\(expense.category.rawValue) • \(expense.formattedDate)")
                                .font(.caption)
                                .foregroundColor(.secondary)
                        }
                        
                        Spacer()
                        
                        Text(expense.formattedAmount)
                            .font(.body)
                            .fontWeight(.bold)
                    }
                }
                .onDelete(perform: store.deleteExpense)
            }
            .navigationTitle("All Expenses")
        }
    }
}

// MARK: - 3. Add Expense View
struct AddExpenseView: View {
    @ObservedObject var store: ExpenseDataStore
    @Binding var selectedTab: Int
    
    @State private var title = ""
    @State private var amountString = ""
    @State private var category = Category.food
    @State private var date = Date()
    @State private var showAlert = false
    
    private var amount: Double {
        Double(amountString) ?? 0.0
    }
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Expense Details")) {
                    TextField("Title (e.g. Lunch)", text: $title)
                    TextField("Amount ($)", text: $amountString)
                        .keyboardType(.decimalPad)
                    
                    Picker("Category", selection: $category) {
                        ForEach(Category.allCases) { cat in
                            Text(cat.rawValue).tag(cat)
                        }
                    }
                    
                    DatePicker("Date", selection: $date, displayedComponents: .date)
                }
                
                Button(action: saveExpense) {
                    Text("Save Expense")
                        .font(.headline)
                        .frame(maxWidth: .infinity)
                        .foregroundColor(.white)
                        .padding(.vertical, 8)
                }
                .listRowBackground(Color.blue)
            }
            .navigationTitle("Add Expense")
            .alert(isPresented: $showAlert) {
                Alert(title: Text("Invalid Input"), message: Text("Please enter a valid title and an amount greater than 0."))
            }
        }
    }
    
    private func saveExpense() {
        guard !title.trimmingCharacters(in: .whitespaces).isEmpty, amount > 0 else {
            showAlert = true
            return
        }
        store.addExpense(title: title, amount: amount, category: category, date: date)
        title = ""
        amountString = ""
        selectedTab = 0 // Return to Home tab
    }
}

// MARK: - 4. Categories View
struct CategoriesView: View {
    @ObservedObject var store: ExpenseDataStore
    
    var body: some View {
        NavigationView {
            List(Category.allCases) { category in
                let spent = store.spending(for: category)
                let total = store.totalSpending
                let percentage = total > 0 ? spent / total : 0.0
                
                VStack(alignment: .leading, spacing: 8) {
                    HStack {
                        Image(systemName: category.icon)
                            .foregroundColor(category.color)
                        Text(category.rawValue)
                            .font(.headline)
                        Spacer()
                        Text(String(format: "$%.2f", spent))
                            .font(.headline)
                    }
                    
                    // Simple progress bar indicator
                    GeometryReader { geometry in
                        ZStack(alignment: .leading) {
                            Capsule()
                                .fill(Color(UIColor.systemGray5))
                                .frame(height: 6)
                            Capsule()
                                .fill(category.color)
                                .frame(width: max(geometry.size.width * CGFloat(percentage), 0), height: 6)
                        }
                    }
                    .frame(height: 6)
                }
                .padding(.vertical, 4)
            }
            .navigationTitle("Categories")
        }
    }
}
