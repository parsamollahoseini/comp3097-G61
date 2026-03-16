import SwiftUI
import CoreData

struct TaskListScreen: View {
    // Core Data: Fetch all tasks that are not completed, sorted by due date
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Task.dueDate, ascending: true)],
        predicate: NSPredicate(format: "isCompleted == %@", NSNumber(value: false)),
        animation: .default
    )
    private var tasks: FetchedResults<Task>

    @State private var showAddTask = false

    var body: some View {
        NavigationStack {
            ScrollView {
                LazyVStack(spacing: 10) {
                    // Core Data: Iterate through fetched tasks
                    ForEach(tasks) { task in
                        NavigationLink(destination: TaskDetailScreenWrapper(task: task)) {
                            TaskCardViewWrapper(task: task)
                        }
                        .buttonStyle(.plain)
                    }
                }
                .padding(.horizontal, 16)
                .padding(.top, 8)
            }
            .background(Color(.systemGroupedBackground))
            .navigationTitle("My Tasks")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        showAddTask = true
                    } label: {
                        Image(systemName: "plus")
                            .fontWeight(.semibold)
                    }
                    .tint(.orange)
                }
            }
            .navigationDestination(isPresented: $showAddTask) {
                AddEditTaskScreen(mode: .add)
            }
        }
    }
}

// MARK: - Wrapper Views for Core Data
/// Wrapper to convert Core Data Task to TaskItem for existing UI components
/// This allows us to use existing TaskCardView and TaskDetailScreen without major changes
private struct TaskCardViewWrapper: View {
    let task: Task

    var body: some View {
        TaskCardView(task: task.toTaskItem())
    }
}

private struct TaskDetailScreenWrapper: View {
    let task: Task

    var body: some View {
        TaskDetailScreen(task: task.toTaskItem())
    }
}

// MARK: - Core Data Extension
/// Extension to convert Core Data Task entity to TaskItem struct
extension Task {
    func toTaskItem() -> TaskItem {
        TaskItem(
            id: self.id ?? UUID(),
            title: self.title ?? "Untitled",
            category: TaskCategory(rawValue: self.category ?? "Personal") ?? .personal,
            dueDate: self.dueDate ?? Date(),
            priority: TaskPriority(rawValue: self.priority ?? "Medium") ?? .medium,
            isCompleted: self.isCompleted
        )
    }
}

#Preview {
    TaskListScreen()
}
