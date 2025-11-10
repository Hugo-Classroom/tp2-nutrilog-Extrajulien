import SwiftUI
import SwiftData
import Charts

struct HomeView: View {
    
    private let maxCalories: Int = 2500
    @State private var usedCalories: Int = 900
    
    var body: some View {
        List {
            Section(header: Text("CALORIES")) {
                HStack {
                    VStack {
                        Text("Restantes").bold().frame(maxWidth: .infinity, alignment: .leading)
                        HStack {
                            Text(formatInt(number: (maxCalories - usedCalories)))
                            Text("cal").fontWeight(.light).foregroundStyle(.secondary)
                        }.frame(maxWidth: .infinity, alignment: .leading)
                    }.frame(width: 80)
                    PercentageCircle(progress: Double(usedCalories)/Double(maxCalories), lineWidth: 6, size: 40)
                    VStack {
                        Text("Consommées").bold().frame(maxWidth: .infinity, alignment: .leading)
                        HStack {
                            Text(formatInt(number: usedCalories))
                            Text("cal").fontWeight(.light).foregroundStyle(.secondary)
                        }.frame(maxWidth: .infinity, alignment: .leading)
                    }.padding(.leading, 30)
                }
            }
            Section(header: Text("MACROS")) {
                
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
                .opacity(0.3)
                .foregroundColor(Color.gray)
            
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


func formatInt(number: Int) -> String {
    let formatter = NumberFormatter()
    formatter.numberStyle = .decimal // Specifies decimal formatting
    formatter.groupingSeparator = "," // Sets the thousand separator to a comma (default for .decimal)
    formatter.usesGroupingSeparator = true // Ensures the separator is used
    
    if let text = formatter.string(from: NSNumber(value: number)) {
        return text
    }
    return "Formatter Error!"
}
