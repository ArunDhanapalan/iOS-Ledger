import SwiftUI

struct CategoryRowView: View {
    let category: Category
    let amount: Double
    let percentage: Double
    let count: Int
    
    var formattedAmount: String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.locale = Locale.current
        return formatter.string(from: NSNumber(value: amount)) ?? String(format: "$%.2f", amount)
    }
    
    var body: some View {
        VStack(spacing: 10) {
            HStack(spacing: 12) {
                // Category Icon
                ZStack {
                    RoundedRectangle(cornerRadius: 10, style: .continuous)
                        .fill(category.color.opacity(0.18))
                        .frame(width: 40, height: 40)
                    
                    Image(systemName: category.iconName)
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundColor(category.color)
                }
                
                VStack(alignment: .leading, spacing: 2) {
                    Text(category.rawValue)
                        .font(.body)
                        .fontWeight(.semibold)
                    
                    Text("\(count) \(count == 1 ? "expense" : "expenses")")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                
                Spacer()
                
                VStack(alignment: .trailing, spacing: 2) {
                    Text(formattedAmount)
                        .font(.system(.body, design: .rounded))
                        .fontWeight(.bold)
                    
                    Text(String(format: "%.1f%%", percentage * 100))
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
            }
            
            // Visual Progress Bar Indicator
            GeometryReader { geometry in
                ZStack(alignment: .leading) {
                    Capsule()
                        .fill(Color(UIColor.tertiarySystemFill))
                        .frame(height: 7)
                    
                    Capsule()
                        .fill(category.color)
                        .frame(width: max(geometry.size.width * CGFloat(percentage), amount > 0 ? 6 : 0), height: 7)
                        .animation(.easeInOut(duration: 0.3), value: percentage)
                }
            }
            .frame(height: 7)
        }
        .padding(14)
        .background(Color(UIColor.secondarySystemGroupedBackground))
        .cornerRadius(14)
    }
}
