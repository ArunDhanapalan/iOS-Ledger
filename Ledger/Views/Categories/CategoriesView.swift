import SwiftUI

struct CategoriesView: View {
    @ObservedObject var store: ExpenseStore
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 16) {
                    // Header Overview Card
                    HStack {
                        VStack(alignment: .leading, spacing: 4) {
                            Text("Total Budget Spent")
                                .font(.caption)
                                .fontWeight(.medium)
                                .foregroundColor(.secondary)
                            
                            Text(formattedTotal)
                                .font(.system(size: 26, weight: .bold, design: .rounded))
                                .foregroundColor(.primary)
                        }
                        
                        Spacer()
                        
                        Text("\(Category.allCases.count) Categories")
                            .font(.caption)
                            .fontWeight(.medium)
                            .padding(.horizontal, 10)
                            .padding(.vertical, 5)
                            .background(Color.accentColor.opacity(0.12))
                            .foregroundColor(.accentColor)
                            .cornerRadius(8)
                    }
                    .padding(16)
                    .background(Color(UIColor.secondarySystemGroupedBackground))
                    .cornerRadius(16)
                    
                    // List of All Categories sorted by spending or default order
                    VStack(spacing: 12) {
                        ForEach(Category.allCases) { category in
                            let amount = store.spending(for: category)
                            let percentage = store.spendingPercentage(for: category)
                            let count = store.count(for: category)
                            
                            CategoryRowView(
                                category: category,
                                amount: amount,
                                percentage: percentage,
                                count: count
                            )
                        }
                    }
                }
                .padding(16)
            }
            .background(Color(UIColor.systemGroupedBackground).ignoresSafeArea())
            .navigationTitle("Categories")
        }
    }
    
    private var formattedTotal: String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.locale = Locale.current
        return formatter.string(from: NSNumber(value: store.totalSpending)) ?? "$0.00"
    }
}
