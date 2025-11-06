import SwiftUI
import SwiftData
import Charts

struct HomeView: View {
    
    private let maxCalories: Int = 2500
    @State private var usedCalories: Int = 900
    
    var body: some View {
        List {
            Section(header: Text("Calories")) {
                PercentageCircle(progress: Double(usedCalories)/Double(maxCalories), lineWidth: 8, size: 50)
            }
        }
    }
}

#Preview {
    HomeView()
        .modelContext(PersistenceController.preview.context)
}

struct PercentageCircle: View {
    var progress: Double // 0.0 to 1.0
    var lineWidth: CGFloat = 20
    var color: Color = .green
    var size: CGFloat = 80;
    
    var body: some View {
        ZStack {
            // Background circle (gray)
            Circle()
                .stroke(lineWidth: lineWidth)
                .opacity(0.1)
                .foregroundColor(color)
            
            // Foreground circle (progress)
            Circle()
                .trim(from: 0, to: progress)
                .stroke(style: StrokeStyle(lineWidth: lineWidth, lineCap: .round))
                .foregroundColor(color)
                .rotationEffect(.degrees(-90)) // Start from top
                .animation(.easeOut(duration: 0.5), value: progress)
        }
        .frame(width: size, height: size)
    }
}
