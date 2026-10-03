import SwiftUI

struct DashboardView: View {
    @ObservedObject var store: ExpenseStore
    @State private var showingAddExpenseSheet = false
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 20) {
                    // MARK: - Metrics Row
                    VStack(spacing: 12) {
                        SummaryCardView(
                            title: "Total Spending",
                            amount: store.totalSpending,
                            icon: "creditcard.fill",
                            subtitle: "\(store.expenses.count) total expenses recorded",
                            gradientColors: [Color.indigo, Color.purple]
                        )
                        
                        SummaryCardView(
                            title: "This Month",
                            amount: store.currentMonthSpending,
                            icon: "calendar",
                            subtitle: "Current billing cycle spending",
                            gradientColors: [Color.blue, Color.cyan]
                        )
                    }
                    
                    // MARK: - Prominent Add Expense Button
                    Button(action: {
                        showingAddExpenseSheet = true
                    }) {
                        HStack {
                            Image(systemName: "plus.circle.fill")
                                .font(.title3)
                            Text("Add New Expense")
                                .font(.headline)
                        }
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 14)
                        .background(
                            LinearGradient(
                                colors: [Color.accentColor, Color.blue],
                                startPoint: .leading,
                                endPoint: .trailing
                            )
                        )
                        .cornerRadius(14)
                        .shadow(color: Color.accentColor.opacity(0.3), radius: 6, x: 0, y: 3)
                    }
                    
                    // MARK: - Category Pie Chart Breakdown
                    VStack(alignment: .leading, spacing: 10) {
                        HStack {
                            Text("Spending by Category")
                                .font(.headline)
                            Spacer()
                        }
                        
                        CategoryPieChartView(store: store)
                    }
                    
                    // MARK: - Recent Expenses
                    VStack(alignment: .leading, spacing: 12) {
                        HStack {
                            Text("Recent Transactions")
                                .font(.headline)
                            Spacer()
                            Text("Latest \(min(store.expenses.count, 5))")
                                .font(.caption)
                                .foregroundColor(.secondary)
                        }
                        
                        if store.expenses.isEmpty {
                            VStack(spacing: 8) {
                                Image(systemName: "tray")
                                    .font(.largeTitle)
                                    .foregroundColor(.secondary)
                                Text("No transactions found")
                                    .font(.subheadline)
                                    .foregroundColor(.secondary)
                            }
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 28)
                            .background(Color(UIColor.secondarySystemGroupedBackground))
                            .cornerRadius(16)
                        } else {
                            VStack(spacing: 0) {
                                ForEach(store.recentExpenses(limit: 5)) { expense in
                                    NavigationLink(destination: ExpenseDetailView(expense: expense, store: store)) {
                                        ExpenseRowView(expense: expense)
                                            .padding(.horizontal, 14)
                                            .padding(.vertical, 8)
                                    }
                                    
                                    if expense.id != store.recentExpenses(limit: 5).last?.id {
                                        Divider()
                                            .padding(.leading, 68)
                                    }
                                }
                            }
                            .background(Color(UIColor.secondarySystemGroupedBackground))
                            .cornerRadius(16)
                        }
                    }
                }
                .padding(16)
            }
            .background(Color(UIColor.systemGroupedBackground).ignoresSafeArea())
            .navigationTitle("Dashboard")
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
}
