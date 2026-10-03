import SwiftUI

struct ExpenseDetailView: View {
    let expense: Expense
    @ObservedObject var store: ExpenseStore
    @Environment(\.presentationMode) var presentationMode
    @State private var showDeleteConfirmation = false
    
    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                // Header Card
                VStack(spacing: 12) {
                    ZStack {
                        Circle()
                            .fill(expense.category.color.opacity(0.15))
                            .frame(width: 72, height: 72)
                        
                        Image(systemName: expense.category.iconName)
                            .font(.system(size: 32))
                            .foregroundColor(expense.category.color)
                    }
                    
                    Text(expense.title)
                        .font(.title2)
                        .fontWeight(.bold)
                        .multilineTextAlignment(.center)
                    
                    Text(expense.formattedAmount)
                        .font(.system(size: 36, weight: .heavy, design: .rounded))
                        .foregroundColor(.primary)
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, 24)
                .background(Color(UIColor.secondarySystemGroupedBackground))
                .cornerRadius(20)
                
                // Details Card
                VStack(spacing: 16) {
                    detailRow(icon: "tag.fill", title: "Category", value: expense.category.rawValue, tintColor: expense.category.color)
                    Divider()
                    detailRow(icon: "calendar", title: "Date & Time", value: expense.formattedFullDate, tintColor: .blue)
                    
                    if let note = expense.note, !note.isEmpty {
                        Divider()
                        VStack(alignment: .leading, spacing: 8) {
                            HStack(spacing: 8) {
                                Image(systemName: "note.text")
                                    .foregroundColor(.purple)
                                Text("Note")
                                    .font(.subheadline)
                                    .foregroundColor(.secondary)
                            }
                            Text(note)
                                .font(.body)
                                .foregroundColor(.primary)
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .padding(12)
                                .background(Color(UIColor.tertiarySystemGroupedBackground))
                                .cornerRadius(10)
                        }
                    }
                }
                .padding(18)
                .background(Color(UIColor.secondarySystemGroupedBackground))
                .cornerRadius(20)
                
                // Delete Action Button
                Button(action: {
                    showDeleteConfirmation = true
                }) {
                    HStack {
                        Image(systemName: "trash.fill")
                        Text("Delete Expense")
                    }
                    .font(.headline)
                    .foregroundColor(.red)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.red.opacity(0.12))
                    .cornerRadius(14)
                }
                .padding(.top, 10)
            }
            .padding(16)
        }
        .background(Color(UIColor.systemGroupedBackground).ignoresSafeArea())
        .navigationTitle("Expense Details")
        .navigationBarTitleDisplayMode(.inline)
        .alert(isPresented: $showDeleteConfirmation) {
            Alert(
                title: Text("Delete Expense"),
                message: Text("Are you sure you want to remove this expense record?"),
                primaryButton: .destructive(Text("Delete")) {
                    store.deleteExpense(id: expense.id)
                    presentationMode.wrappedValue.dismiss()
                },
                secondaryButton: .cancel()
            )
        }
    }
    
    @ViewBuilder
    private func detailRow(icon: String, title: String, value: String, tintColor: Color) -> some View {
        HStack {
            Image(systemName: icon)
                .font(.system(size: 16))
                .foregroundColor(tintColor)
                .frame(width: 24)
            
            Text(title)
                .font(.subheadline)
                .foregroundColor(.secondary)
            
            Spacer()
            
            Text(value)
                .font(.subheadline)
                .fontWeight(.semibold)
                .foregroundColor(.primary)
        }
    }
}
