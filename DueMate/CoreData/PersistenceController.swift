import CoreData
import Foundation

// MARK: - PersistenceController
/// Manages the Core Data stack for the DueMate app
/// This controller handles the NSPersistentContainer and provides access to the viewContext
struct PersistenceController {
    /// Shared singleton instance for the app
    static let shared = PersistenceController()

    /// Preview instance with in-memory store for SwiftUI previews
    static var preview: PersistenceController = {
        let controller = PersistenceController(inMemory: true)
        let viewContext = controller.container.viewContext

        // Create sample tasks for preview
        for i in 0..<5 {
            let task = Task(context: viewContext)
            task.id = UUID()
            task.title = "Sample Task \(i + 1)"
            task.category = ["Work", "School", "Personal"].randomElement() ?? "Personal"
            task.dueDate = Calendar.current.date(byAdding: .day, value: i, to: Date()) ?? Date()
            task.priority = ["Low", "Medium", "High"].randomElement() ?? "Medium"
            task.isCompleted = false
            task.createdAt = Date()
        }

        do {
            try viewContext.save()
        } catch {
            let nsError = error as NSError
            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
        }

        return controller
    }()

    /// The Core Data persistent container
    let container: NSPersistentContainer

    /// Initialize the persistence controller
    /// - Parameter inMemory: If true, creates an in-memory store (useful for previews/testing)
    init(inMemory: Bool = false) {
        container = NSPersistentContainer(name: "DueMate")

        if inMemory {
            // Use in-memory store for previews/testing
            container.persistentStoreDescriptions.first?.url = URL(fileURLWithPath: "/dev/null")
        }

        // Load the persistent store
        container.loadPersistentStores { description, error in
            if let error = error {
                // In production, handle this error appropriately
                fatalError("Core Data failed to load: \(error.localizedDescription)")
            }
        }

        // Enable automatic merging of changes from parent contexts
        container.viewContext.automaticallyMergesChangesFromParent = true
    }

    /// Save the current context if there are changes
    func save() {
        let context = container.viewContext

        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nsError = error as NSError
                print("Error saving context: \(nsError), \(nsError.userInfo)")
            }
        }
    }
}
