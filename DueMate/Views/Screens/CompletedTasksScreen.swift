import SwiftUI
import CoreData

struct CompletedTasksScreen: View {
    // Core Data: Fetch all completed tasks, sorted by completion date
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Task.dueDate, ascending: false)],
        predicate: NSPredicate(format: "isCompleted == %@", NSNumber(value: true)),
        animation: .default
    )
    private var completedTasks: FetchedResults<Task>

    var body: some View {
        NavigationStack {
            ScrollView {
                LazyVStack(spacing: 10) {
                    ForEach(completedTasks) { task in
                        NavigationLink(destination: TaskDetailScreen(task: task)) {
                            TaskCardView(task: task.toTaskItem())
                        }
                        .buttonStyle(.plain)
                    }
                }
                .padding(.horizontal, 16)
                .padding(.top, 8)
            }
            .background(Color(.systemGroupedBackground))
            .navigationTitle("Completed Tasks")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}

#Preview {
    CompletedTasksScreen()
        .environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
}
