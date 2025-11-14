
import SwiftUI

struct HomeView: View {
    var body: some View {
        TabView {
            DailySummaryView().tabItem {
                Label("Journée", systemImage: "sun.max.fill")
            }
            DailyChartsView().tabItem {
                Label("Graphiques", systemImage: "chart.bar.fill")
            }
        }
    }
}

#Preview {
    HomeView()
}

