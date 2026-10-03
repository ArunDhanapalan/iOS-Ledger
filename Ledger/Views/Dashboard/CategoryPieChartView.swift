import SwiftUI

struct PieSliceData: Identifiable {
    let id = UUID()
    let category: Category
    let amount: Double
    let startAngle: Angle
    let endAngle: Angle
    let percentage: Double
}

struct PieSliceShape: Shape {
    let startAngle: Angle
    let endAngle: Angle
    
    func path(in rect: CGRect) -> Path {
        var path = Path()
        let center = CGPoint(x: rect.midX, y: rect.midY)
        let radius = min(rect.width, rect.height) / 2
        
        path.move(to: center)
        path.addArc(
            center: center,
            radius: radius,
            startAngle: startAngle - Angle(degrees: 90),
            endAngle: endAngle - Angle(degrees: 90),
            clockwise: false
        )
        path.closeSubpath()
        return path
    }
}

struct CategoryPieChartView: View {
    @ObservedObject var store: ExpenseStore
    
    private var slices: [PieSliceData] {
        let total = store.totalSpending
        guard total > 0 else { return [] }
        
        var currentAngle: Double = 0
        var result: [PieSliceData] = []
        
        for category in Category.allCases {
            let catAmount = store.spending(for: category)
            if catAmount > 0 {
                let fraction = catAmount / total
                let sliceDegrees = fraction * 360
                let start = Angle(degrees: currentAngle)
                let end = Angle(degrees: currentAngle + sliceDegrees)
                
                result.append(
                    PieSliceData(
                        category: category,
                        amount: catAmount,
                        startAngle: start,
                        endAngle: end,
                        percentage: fraction * 100
                    )
                )
                currentAngle += sliceDegrees
            }
        }
        return result
    }
    
    var body: some View {
        VStack(spacing: 20) {
            if slices.isEmpty {
                VStack(spacing: 8) {
                    Image(systemName: "chart.pie")
                        .font(.system(size: 44))
                        .foregroundColor(.secondary)
                    Text("No Expenses Recorded Yet")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
                .frame(height: 180)
            } else {
                // Donut Chart
                ZStack {
                    ForEach(slices) { slice in
                        PieSliceShape(startAngle: slice.startAngle, endAngle: slice.endAngle)
                            .fill(slice.category.color)
                    }
                    
                    // Donut center hole
                    Circle()
                        .fill(Color(UIColor.secondarySystemGroupedBackground))
                        .frame(width: 95, height: 95)
                        .overlay(
                            VStack(spacing: 2) {
                                Text("Total")
                                    .font(.caption2)
                                    .fontWeight(.medium)
                                    .foregroundColor(.secondary)
                                Text(formattedTotal)
                                    .font(.system(size: 13, weight: .bold, design: .rounded))
                                    .foregroundColor(.primary)
                                    .minimumScaleFactor(0.7)
                                    .lineLimit(1)
                                    .padding(.horizontal, 4)
                            }
                        )
                }
                .frame(width: 170, height: 170)
                .padding(.top, 4)
                
                // Legend
                LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 10) {
                    ForEach(slices) { slice in
                        HStack(spacing: 8) {
                            Circle()
                                .fill(slice.category.color)
                                .frame(width: 10, height: 10)
                            
                            Text(slice.category.rawValue)
                                .font(.caption)
                                .foregroundColor(.primary)
                                .lineLimit(1)
                            
                            Spacer()
                            
                            Text(String(format: "%.0f%%", slice.percentage))
                                .font(.caption2)
                                .fontWeight(.semibold)
                                .foregroundColor(.secondary)
                        }
                        .padding(.horizontal, 8)
                        .padding(.vertical, 4)
                        .background(Color(UIColor.tertiarySystemGroupedBackground))
                        .cornerRadius(8)
                    }
                }
            }
        }
        .padding(16)
        .background(Color(UIColor.secondarySystemGroupedBackground))
        .cornerRadius(18)
    }
    
    private var formattedTotal: String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.locale = Locale.current
        return formatter.string(from: NSNumber(value: store.totalSpending)) ?? "$0.00"
    }
}
