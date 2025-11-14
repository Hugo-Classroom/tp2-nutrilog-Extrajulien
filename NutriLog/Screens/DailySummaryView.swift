import SwiftUI
import SwiftData
import Charts

struct DailySummaryView: View {
    
    private let maxCalories: Int = 2500
    private var usedCalories: Int = 900
    @State var foods: [FoodEntry] = []
    
    @State private var showAddMeal = false
    
    var body: some View {
        NavigationView {
            List {
                Section(header: Text("CALORIES")) {
                    HStack {
                        VStack {
                            Text("Restantes").bold().frame(maxWidth: .infinity, alignment: .leading)
                            HStack {
                                Text(formatInt(number: (maxCalories - getTotalCalories())))
                                Text("cal").fontWeight(.light).foregroundStyle(.secondary)
                            }.frame(maxWidth: .infinity, alignment: .leading)
                        }.frame(width: 80)
                        PercentageCircle(progress: Double(getTotalCalories())/Double(maxCalories), lineWidth: 6, size: 40)
                        VStack {
                            Text("Consommées").bold().frame(maxWidth: .infinity, alignment: .leading)
                            HStack {
                                Text(formatInt(number: getTotalCalories()))
                                Text("cal").fontWeight(.light).foregroundStyle(.secondary)
                            }.frame(maxWidth: .infinity, alignment: .leading)
                        }.padding(.leading, 30)
                    }
                }
                Section(header: Text("MACROS")) {
                    HStack {
                        infoBar(name: "Protéines", color: .red, quantity: getTotalProteins(), max: 150).frame(maxWidth: .infinity)
                        infoBar(name: "Glucides", color: .purple, quantity: getTotalCarbs(), max: 125).frame(maxWidth: .infinity)
                        infoBar(name: "Lipides", color: .blue, quantity: getTotalFat(), max: 100).frame(maxWidth: .infinity)
                    }.frame(maxWidth: .infinity)
                }
                Section(header: Text("Déjeuner")) {
                    ForEach(foods.filter { $0.mealType == .breakfast }) { food in
                        NavigationLink (destination: FoodDetailView()) {
                            FoodEntryView(name: food.food!.name, desc: food.food?.desc! ?? "", kcal: food.calories)
                        }
                    }
                    
                    
                }
                Section(header: Text("Dîner")) {
                    ForEach(foods.filter { $0.mealType == .lunch }) { food in
                        NavigationLink (destination: FoodDetailView()) {
                            FoodEntryView(name: food.food!.name, desc: food.food?.desc! ?? "", kcal: food.calories)
                        }
                    }
                }
                Section(header: Text("Souper")) {
                    ForEach(foods.filter { $0.mealType == .dinner }) { food in
                        NavigationLink (destination: FoodDetailView()) {
                            FoodEntryView(name: food.food!.name, desc: food.food?.desc! ?? "", kcal: food.calories)
                        }
                    }
                }
            }.navigationTitle("Aujourd'hui")
                .toolbar {
                    Button("", systemImage: "plus") {
                        showAddMeal = true
                    }
                }
        }.sheet(isPresented: $showAddMeal, onDismiss: {
            loadFoods()
        }) {
            AddMealView(showAddMeal: $showAddMeal)
        }
    }
    
    func loadFoods() {
        let context = PersistenceController.shared.context
        let descriptor = FetchDescriptor<FoodEntry>()

        do {
            foods = try context.fetch(descriptor)
        } catch {
            print("Fetch error: \(error)")
        }
    }
    
    func getTotalProteins() -> Int {
        var count: Int = 0
        foods.forEach({food in
            count += (Int) (food.food!.protein * food.servingSize / 100)
        })
        return count
    }
    
    func getTotalCarbs() -> Int {
        var count: Int = 0
        foods.forEach({food in
            count += (Int) (food.food!.carbs * food.servingSize / 100)
        })
        return count
    }
    
    func getTotalFat() -> Int {
        var count: Int = 0
        foods.forEach({food in
            count += (Int) (food.food!.fat * food.servingSize / 100)
        })
        return count
    }
    
    func getTotalCalories() -> Int {
        var count: Int = 0
        foods.forEach({food in
            count += (Int) (food.calories)
        })
        return count
    }
}

struct SectionHeader: View {
    let title: String
    
    var body: some View {
        
    }
}

#Preview {
    DailySummaryView()
        .modelContext(PersistenceController.preview.context)
}

struct PercentageCircle: View {
    var progress: Double // 0.0 to 1.0
    var lineWidth: CGFloat = 20
    var color: Color = .green
    var size: CGFloat = 80
    
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

struct PercentageBar: View {
    var progress: Double // 0.0 to 1.0
    var lineWidth: CGFloat = 20
    var color: Color = .green
    var size: CGFloat = 80
    
    var body: some View {
        ZStack {
            Rectangle()
                .trim(from: 0, to: 0.49)
                .stroke(style: StrokeStyle(lineWidth: lineWidth, lineCap: .round))
                .opacity(0.3)
                .foregroundColor(Color.gray)
            
            Rectangle()
                .trim(from: 0, to: progress/2)
                .stroke(style: StrokeStyle(lineWidth: lineWidth, lineCap: .round))
                .foregroundColor(color)
                .animation(.easeOut(duration: 0.5), value: progress)
        }.frame(width: size, height: 1)
        
    }
}


func formatInt(number: Int) -> String {
    let formatter = NumberFormatter()
    formatter.numberStyle = .decimal
    formatter.groupingSeparator = ","
    formatter.usesGroupingSeparator = true
    
    if let text = formatter.string(from: NSNumber(value: number)) {
        return text
    }
    return "Formatter Error!"
}


struct infoBar: View {
    let name: String
    let color: Color
    let quantity: Int
    let max: Int
    let size: CGFloat = 20
    var body: some View {
        VStack  {
            HStack {
                letterBubble(letter: getFirstChar(text: name), color: color).frame(width: size, height: size)
                Text(name).foregroundStyle(color).font(.footnote).frame(maxWidth: .infinity, alignment: .leading).bold()
            }
            PercentageBar(progress: (Double)(quantity) / (Double)(max), lineWidth: 5, color: color).frame(maxWidth: .infinity, alignment: .leading).padding(.leading, 4)
            HStack {
                Text(String(quantity)).bold()
                Text("/ \(max)").foregroundStyle(.secondary)
            }.frame(maxWidth: .infinity, alignment: .leading).padding(.leading, 4)
                
        }
    }
}

struct letterBubble: View {
    let letter: String
    let color: Color
    
    var body: some View {
        ZStack {
            Circle()
                .fill(color)
            Text(letter).foregroundStyle(Color.white).font(.footnote)
        }
    }
}

struct FoodEntryView: View {
    let name: String
    let desc: String
    let kcal: Double
    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                Text(name).font(.title3)
                Text(desc)
            }.frame(maxWidth: .infinity, alignment: .leading)
            Spacer()
            Text(String(format: "%.1f kcal", kcal))
        }
    }
}


func getFirstChar(text: String) -> String {
    if let char = text.first {
        return String(char)
    }
    return "Error"
}
