import SwiftUI

struct MainTabView: View {
    @StateObject private var store = ExpenseStore()
    
    var body: some View {
        TabView {
            DashboardView(store: store)
                .tabItem {
                    Label("Home", systemImage: "house.fill")
                }
            
            ExpenseListView(store: store)
                .tabItem {
                    Label("Expenses", systemImage: "list.bullet.rectangle.portrait.fill")
                }
            
            CategoriesView(store: store)
                .tabItem {
                    Label("Categories", systemImage: "chart.bar.fill")
                }
        }
        .tint(.blue)
    }
}
