import SwiftUI

struct ExpenseListView: View {
    @ObservedObject var store: ExpenseStore
    @State private var showingAddExpenseSheet = false
    @State private var selectedFilterCategory: Category? = nil
    @State private var searchText: String = ""
    
    private var filteredExpenses: [Expense] {
        store.expenses.filter { expense in
            let matchesCategory = selectedFilterCategory == nil || expense.category == selectedFilterCategory
            let matchesSearch = searchText.isEmpty ||
                expense.title.localizedCaseInsensitiveContains(searchText) ||
                (expense.note?.localizedCaseInsensitiveContains(searchText) ?? false)
            return matchesCategory && matchesSearch
        }
    }
    
    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                // Category Filter Chips
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 8) {
                        filterChip(title: "All", isSelected: selectedFilterCategory == nil) {
                            selectedFilterCategory = nil
                        }
                        
                        ForEach(Category.allCases) { category in
                            filterChip(
                                title: category.rawValue,
                                isSelected: selectedFilterCategory == category,
                                icon: category.iconName,
                                activeColor: category.color
                            ) {
                                if selectedFilterCategory == category {
                                    selectedFilterCategory = nil
                                } else {
                                    selectedFilterCategory = category
                                }
                            }
                        }
                    }
                    .padding(.horizontal, 16)
                    .padding(.vertical, 10)
                }
                .background(Color(UIColor.secondarySystemGroupedBackground))
                
                Divider()
                
                // Expenses List
                if filteredExpenses.isEmpty {
                    VStack(spacing: 12) {
                        Spacer()
                        Image(systemName: "list.clipboard")
                            .font(.system(size: 48))
                            .foregroundColor(.secondary)
                        Text(store.expenses.isEmpty ? "No Expenses Added Yet" : "No Matching Expenses")
                            .font(.headline)
                            .foregroundColor(.secondary)
                        Text(store.expenses.isEmpty ? "Tap the '+' button to log your first transaction." : "Try clearing filters or search.")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                            .multilineTextAlignment(.center)
                            .padding(.horizontal)
                        Spacer()
                    }
                } else {
                    List {
                        ForEach(filteredExpenses) { expense in
                            NavigationLink(destination: ExpenseDetailView(expense: expense, store: store)) {
                                ExpenseRowView(expense: expense)
                            }
                        }
                        .onDelete { indexSet in
                            deleteItems(at: indexSet)
                        }
                    }
                    .listStyle(.insetGrouped)
                }
            }
            .navigationTitle("All Expenses")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        showingAddExpenseSheet = true
                    }) {
                        Image(systemName: "plus")
                            .font(.system(size: 16, weight: .bold))
                    }
                }
            }
            .sheet(isPresented: $showingAddExpenseSheet) {
                AddExpenseView(store: store)
            }
        }
    }
    
    private func deleteItems(at indexSet: IndexSet) {
        for index in indexSet {
            let expenseToDelete = filteredExpenses[index]
            store.deleteExpense(id: expenseToDelete.id)
        }
    }
    
    @ViewBuilder
    private func filterChip(title: String, isSelected: Bool, icon: String? = nil, activeColor: Color = .blue, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            HStack(spacing: 5) {
                if let icon = icon {
                    Image(systemName: icon)
                        .font(.caption2)
                }
                Text(title)
                    .font(.caption)
                    .fontWeight(.medium)
            }
            .padding(.horizontal, 12)
            .padding(.vertical, 7)
            .background(isSelected ? activeColor : Color(UIColor.tertiarySystemGroupedBackground))
            .foregroundColor(isSelected ? .white : .primary)
            .cornerRadius(20)
        }
    }
}
