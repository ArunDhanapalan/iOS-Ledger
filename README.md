# Expense Tracker (iOS) - Lab Project

A clean, beginner-friendly iOS Expense Tracker application built with **Swift** and **SwiftUI**. Designed with a minimal **3-file architecture** specifically tailored for easy physical lab record printing and straightforward viva explanation.

---

## 🗂️ Minimal 3-File Structure

```
Ledger/
├── ExpenseTrackerApp.swift   # App entry point (@main)
├── Expense.swift             # Data models (Category enum & Expense struct)
└── ContentView.swift         # All UI views, TabView, Swift Charts & persistence store
```

### How the Files Interact:
1. **`ExpenseTrackerApp.swift`**: Bootstraps the application and launches `ContentView` as the root view.
2. **`Expense.swift`**: Defines the data blueprint: the `Expense` model (`id`, `title`, `amount`, `category`, `date`) and the `Category` enum with icons and colors.
3. **`ContentView.swift`**:
   - Manages state and local `UserDefaults` persistence with `ExpenseDataStore` (`ObservableObject`).
   - Renders a 4-tab `TabView`:
     - **Home**: Total spending card, Apple Swift Charts donut chart (`SectorMark`), and recent transactions preview.
     - **Expenses**: Full list of logged expenses with swipe-to-delete.
     - **Add Expense**: Form with validation (requires title and amount > 0).
     - **Categories**: Spending breakdown per category with visual progress bars.

---

## 🚀 Building on Codemagic (Windows Workflow)

1. **Commit and Push to GitHub**:
   ```bash
   git add .
   git commit -m "Bare minimum 3-file iOS Expense Tracker"
   git push origin main
   ```
2. **Build on Codemagic**:
   - Open [Codemagic](https://codemagic.io/) and start a build on `ArunDhanapalan/iOS-Ledger`.
   - The included `codemagic.yaml` builds the simulator `.app` and packages `Ledger-Simulator.zip`.
3. **App Preview & Screenshots**:
   - Preview directly inside Codemagic's web simulator or upload `Ledger-Simulator.zip` to [Appetize.io](https://appetize.io/) (free) to take screenshots for your lab record.

---

## 🎓 Lab Viva Questions & Concept Summary

- **How is data persisted?**
  Using `UserDefaults` with `JSONEncoder` and `JSONDecoder` in `ExpenseDataStore`. Whenever the `@Published var expenses` array changes, the `didSet` observer automatically encodes and saves the data.
- **How does the pie/donut chart work?**
  Using Apple's official `Charts` framework with `SectorMark(angle:innerRadius:)` to render an interactive donut chart by category.
- **How are categories represented?**
  As an `enum Category: String, CaseIterable, Codable, Identifiable` containing 5 cases: `Food`, `Travel`, `Shopping`, `Bills`, `Other`.
- **How is user input validated?**
  In `AddExpenseView`, the save button checks `!title.trimmingCharacters(in: .whitespaces).isEmpty` and `amount > 0` before adding the expense.
