import SwiftUI

struct AddExpenseView: View {
    @ObservedObject var store: ExpenseStore
    @Environment(\.presentationMode) var presentationMode
    
    @State private var title: String = ""
    @State private var amountString: String = ""
    @State private var selectedCategory: Category = .food
    @State private var date: Date = Date()
    @State private var note: String = ""
    @State private var showValidationError: Bool = false
    @State private var errorMessage: String = ""
    
    private var parsedAmount: Double {
        Double(amountString.replacingOccurrences(of: ",", with: ".")) ?? 0.0
    }
    
    private var isFormValid: Bool {
        !title.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty && parsedAmount > 0
    }
    
    var body: some View {
        NavigationView {
            Form {
                // Section 1: Amount & Title
                Section(header: Text("Expense Information")) {
                    HStack {
                        Text(Locale.current.currencySymbol ?? "$")
                            .font(.title2)
                            .fontWeight(.bold)
                            .foregroundColor(.secondary)
                        
                        TextField("0.00", text: $amountString)
                            .keyboardType(.decimalPad)
                            .font(.system(size: 28, weight: .bold, design: .rounded))
                            .foregroundColor(.primary)
                    }
                    .padding(.vertical, 4)
                    
                    TextField("Expense title (e.g. Groceries)", text: $title)
                        .font(.body)
                }
                
                // Section 2: Category Selector
                Section(header: Text("Category")) {
                    Picker("Category", selection: $selectedCategory) {
                        ForEach(Category.allCases) { cat in
                            HStack {
                                Image(systemName: cat.iconName)
                                    .foregroundColor(cat.color)
                                Text(cat.rawValue)
                            }
                            .tag(cat)
                        }
                    }
                    .pickerStyle(.menu)
                }
                
                // Section 3: Date
                Section(header: Text("Date")) {
                    DatePicker("Expense Date", selection: $date, in: ...Date(), displayedComponents: [.date, .hourAndMinute])
                        .datePickerStyle(.compact)
                }
                
                // Section 4: Optional Note
                Section(header: Text("Optional Note")) {
                    TextField("Add details, receipt reference, or note...", text: $note)
                }
            }
            .navigationTitle("Add Expense")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        presentationMode.wrappedValue.dismiss()
                    }
                }
                
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") {
                        saveAction()
                    }
                    .fontWeight(.semibold)
                    .disabled(!isFormValid)
                }
            }
            .alert(isPresented: $showValidationError) {
                Alert(
                    title: Text("Invalid Expense"),
                    message: Text(errorMessage),
                    dismissButton: .default(Text("OK"))
                )
            }
        }
    }
    
    private func saveAction() {
        guard !title.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else {
            errorMessage = "Please enter an expense title."
            showValidationError = true
            return
        }
        
        guard parsedAmount > 0 else {
            errorMessage = "The amount must be greater than zero."
            showValidationError = true
            return
        }
        
        store.addExpense(
            title: title,
            amount: parsedAmount,
            category: selectedCategory,
            date: date,
            note: note
        )
        
        presentationMode.wrappedValue.dismiss()
    }
}
