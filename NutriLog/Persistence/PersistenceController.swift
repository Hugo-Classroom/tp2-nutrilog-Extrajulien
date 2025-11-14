import Foundation
import SwiftData

@MainActor
final class PersistenceController {
    // Ceci est la manière de faire un Singleton en Swift
    static let shared = PersistenceController()

    let container: ModelContainer
    
    var context: ModelContext {
        container.mainContext
    }

    private init(inMemory: Bool = false) {
        do {
            let schema = Schema([
                Food.self,
                FoodEntry.self
            ])

            let configuration = ModelConfiguration(
                isStoredInMemoryOnly: inMemory
            )

            container = try ModelContainer(
                for: schema,
                configurations: [configuration]
            )
        } catch {
            fatalError("Failed to initialize SwiftData container: \(error)")
        }
    }

    /// Création d'un conteneur SwiftData pour les Preview
    static var preview: PersistenceController = {
        let controller = PersistenceController(inMemory: true)
        let context = controller.container.mainContext
        
        // TODO: Ajouter tous les mocks pour les Preview
        
        
        return controller
    }()
}
