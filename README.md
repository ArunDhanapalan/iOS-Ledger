# Ledger - iOS Expense Tracker

A modern, beginner-friendly iOS Expense Tracker app built with **Swift** and **SwiftUI**. Designed specifically for college lab projects, demonstrations, and viva examinations.

---

## 📱 Features

- **Dashboard / Home**:
  - Total spending card with gradient styling.
  - Current month's spending card.
  - Interactive pure SwiftUI Donut / Pie Chart with category legend.
  - Recent transactions list with direct navigation to details.
  - Prominent "Add New Expense" button.
- **Add Expense**:
  - Validation: requires title and amount > 0.
  - Category picker with custom icons and colors.
  - Date and time picker.
  - Optional note input.
- **Expense List**:
  - Complete list of all logged expenses.
  - Filter chips by category (`All`, `Food`, `Travel`, `Shopping`, `Education`, `Bills`, `Entertainment`, `Other`).
  - Search by expense title and notes.
  - Swipe-to-delete gesture.
- **Categories Tab**:
  - Visual progress bar indicators showing percentage of total expenses.
  - Total spending and transaction count for each category.
- **Local Persistence**:
  - Built using `UserDefaults` and `JSONEncoder` / `JSONDecoder`.
  - Automatically loads sample records on the very first launch so the dashboard is immediately populated.
- **Modern UI**:
  - Fully supports Light Mode & Dark Mode natively.
  - Card-based layout with SF Symbols and Apple Human Interface Guidelines.
  - 100% zero third-party dependencies (no CocoaPods, no SPM packages required).

---

## 🗂️ Project Structure

```
Ledger/
├── .gitignore
├── codemagic.yaml
├── README.md
├── Ledger.xcodeproj/
│   ├── project.pbxproj
│   └── xcshareddata/
│       └── xcschemes/
│           └── Ledger.xcscheme
└── Ledger/
    ├── Info.plist
    ├── App/
    │   └── LedgerApp.swift
    ├── Models/
    │   ├── Category.swift
    │   └── Expense.swift
    ├── ViewModels/
    │   └── ExpenseStore.swift
    ├── Views/
    │   ├── MainTabView.swift
    │   ├── Dashboard/
    │   │   ├── DashboardView.swift
    │   │   ├── CategoryPieChartView.swift
    │   │   └── SummaryCardView.swift
    │   ├── Expenses/
    │   │   ├── ExpenseListView.swift
    │   │   ├── ExpenseRowView.swift
    │   │   └── ExpenseDetailView.swift
    │   ├── AddExpense/
    │   │   └── AddExpenseView.swift
    │   └── Categories/
    │       ├── CategoriesView.swift
    │       └── CategoryRowView.swift
    ├── Assets.xcassets/
    │   ├── AccentColor.colorset/
    │   └── AppIcon.appiconset/
    └── Preview Content/
        └── Preview Assets.xcassets/
```

---

## 🚀 Building on Codemagic (Windows Workflow)

You do **not** need a physical Mac or paid Apple Developer account to build and run this project.

### Step 1: Push Project to GitHub
1. Open PowerShell or Git Bash in this project directory:
   ```bash
   git init
   git add .
   git commit -m "Initial commit of Ledger iOS app"
   ```
2. Create a new repository on [GitHub](https://github.com/new) named `Ledger`.
3. Link and push your code:
   ```bash
   git remote add origin https://github.com/<your-username>/Ledger.git
   git branch -M main
   git push -u origin main
   ```

### Step 2: Connect with Codemagic
1. Sign in to [Codemagic](https://codemagic.io/) with your GitHub account.
2. Click **Add application**.
3. Select your repository `Ledger` and choose **iOS App**.
4. Codemagic will detect the included `codemagic.yaml` file automatically.
5. Click **Start new build** using the `iOS App (Simulator & Preview Build)` workflow.

### Step 3: Run & Capture Screenshots
1. Once the build finishes (takes ~2 to 3 minutes), Codemagic produces:
   - `Ledger-Simulator.zip`
2. **App Preview / In-Browser Simulator**:
   - You can use Codemagic's built-in App Preview, or
   - Upload the resulting `Ledger-Simulator.zip` to [Appetize.io](https://appetize.io/) (free) to run the iOS app directly inside your web browser on Windows!
   - Capture high-resolution screenshots for your college lab report and viva presentation.

---

## 🎓 Lab Viva Reference (Explanation of Files & Concepts)

| File | Role | Key Concepts Demonstrated |
|---|---|---|
| `LedgerApp.swift` | App Entry Point | `@main`, `App` protocol, `WindowGroup`, SwiftUI lifecycle. |
| `Category.swift` | Category Enum | `CaseIterable`, `Identifiable`, `Codable`, SF Symbols mapping, custom `Color` properties. |
| `Expense.swift` | Model | `struct`, `Identifiable`, `Codable`, `UUID`, `NumberFormatter` for currency, `DateFormatter`. |
| `ExpenseStore.swift` | ViewModel / Store | `@Published`, `ObservableObject`, `UserDefaults`, `JSONEncoder`/`JSONDecoder`, functional Swift (`map`, `filter`, `reduce`). |
| `MainTabView.swift` | Navigation Root | `TabView`, `Label`, `Image(systemName:)`, system tinting. |
| `DashboardView.swift` | Home Screen | `ScrollView`, `@State`, sheet presentation (`.sheet`), metric cards, subview composition. |
| `CategoryPieChartView.swift` | Data Visualization | Custom `Shape`, `Path`, `Angle`, `GeometryReader`, mathematical arc drawing (`addArc`), Donut hole overlay. |
| `SummaryCardView.swift` | Metric Card | `LinearGradient`, rounded corners, typography hierarchy, `shadow`. |
| `AddExpenseView.swift` | Form Input | `Form`, `Section`, `TextField`, `Picker`, `DatePicker`, input validation (amount > 0, non-empty title). |
| `ExpenseListView.swift` | All Expenses | `List`, dynamic filtering, category chip selection, swipe-to-delete (`.onDelete`). |
| `ExpenseDetailView.swift` | Detail Screen | Navigation parameters, alert dialogs (`Alert`), deletion callback. |
| `CategoriesView.swift` | Categories Screen | Category summary, custom animated progress bars. |
| `CategoryRowView.swift` | Category Item | `GeometryReader`, capsule indicators, percentage calculation. |
