import SwiftUI

struct ExpenseRowView: View {
    let expense: Expense
    
    var body: some View {
        HStack(spacing: 14) {
            // Category Icon Badge
            ZStack {
                RoundedRectangle(cornerRadius: 12, style: .continuous)
                    .fill(expense.category.color.opacity(0.18))
                    .frame(width: 44, height: 44)
                
                Image(systemName: expense.category.iconName)
                    .font(.system(size: 18, weight: .semibold))
                    .foregroundColor(expense.category.color)
            }
            
            // Title & Date
            VStack(alignment: .leading, spacing: 4) {
                Text(expense.title)
                    .font(.body)
                    .fontWeight(.medium)
                    .foregroundColor(.primary)
                    .lineLimit(1)
                
                HStack(spacing: 6) {
                    Text(expense.category.rawValue)
                        .font(.caption2)
                        .fontWeight(.medium)
                        .padding(.horizontal, 6)
                        .padding(.vertical, 2)
                        .background(expense.category.color.opacity(0.15))
                        .foregroundColor(expense.category.color)
                        .cornerRadius(4)
                    
                    Text(expense.formattedDate)
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
            }
            
            Spacer()
            
            // Amount
            Text(expense.formattedAmount)
                .font(.system(.body, design: .rounded))
                .fontWeight(.bold)
                .foregroundColor(.primary)
        }
        .padding(.vertical, 4)
    }
}
