import SwiftUI
import SwiftData

struct AddMealView: View {
    
    @Binding var showAddMeal: Bool
    @State var portion: Int = 100
    @State var foodType: MealType = MealType.breakfast
    @State var meal: Food = MockData.darkChocolate
    var body: some View {
        VStack {
            HStack {
                Button("", systemImage: "xmark") {
                    showAddMeal = false
                }.font(.title).frame(width: 30, height: 30).padding(.leading, 32).accentColor(.black)
                Spacer()
                Text("Ajouter une entrée").padding(.trailing, 44)
                Spacer()
            }.padding(.top, 32).padding(.bottom, 32)
            
            Menu {
                ForEach(MockData.foods, id: \.name) { food in
                    Button(food.name) {
                        meal = food
                    }
                }
            }label: {
                HStack {
                    Text(meal.name)
                    Image(systemName: "chevron.up.chevron.down")
                }
            }.padding(.bottom, 40)
            HStack {
                Text("Portions: \(portion) g").padding(.leading)
                Spacer()
                Stepper("", value: $portion, in: 0...3000, step: 10).padding(.trailing)
            }
            HStack {
                Picker("Choices", selection: $foodType) {
                    Text("Déjeuner").tag(MealType.breakfast)
                    Text("Dîner").tag(MealType.lunch)
                    Text("Souper").tag(MealType.dinner)
                        }
                        .pickerStyle(.segmented)
                        .padding()
            }
            VStack {
                HStack {
                    Text("Macros pour \(portion) g").padding(.leading).bold()
                    Spacer()
                }
                
                infoElement(name: "Calories:", value: meal.calories * (Double) (portion) / 100,unit: "kcal")
                infoElement(name: "Protéines:", value: meal.protein * (Double) (portion) / 100, unit: "g")
                infoElement(name: "Glucides:", value: meal.carbs * (Double) (portion) / 100, unit: "g")
                infoElement(name: "Gras:", value: meal.fat * (Double) (portion) / 100, unit: "g")
            }.frame(maxWidth: .infinity).padding(.vertical).background(Color.lightGray).cornerRadius(4).padding(.horizontal)
            
            
            Spacer()
            Button(action: {
                saveMeal()
                showAddMeal = false
            }) {
                Text("Sauvegarder").font(.title3).frame(maxWidth: .infinity, maxHeight: 50).background(Color.accent).foregroundStyle(Color.white).cornerRadius(8).padding(.horizontal)
            }
        }
    }
    
    func saveMeal() {
        let context = PersistenceController.shared.context
        context.insert(FoodEntry.init(food: meal, servingSize: (Double)(portion), mealType: foodType))
        do {
            try context.save()
            print("Meal saved successfully!")
        } catch {
            print("Failed to save meal: \(error)")
        }
    }
}

#Preview {
    AddMealView(showAddMeal: .constant(true))
}




struct infoElement: View {
    let name: String
    let value: Double
    let unit: String
    var body: some View {
        HStack {
            Text(name).padding(.leading)
            Spacer()
            Text(String(format: "%.1f \(unit)", value)).padding(.trailing)
        }
    }
}
