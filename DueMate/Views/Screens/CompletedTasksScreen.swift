import SwiftUI
import CoreData

struct CompletedTasksScreen: View {
    @Environment(\.managedObjectContext) private var viewContext

    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Task.dueDate, ascending: false)],
        predicate: NSPredicate(format: "isCompleted == %@", NSNumber(value: true)),
        animation: .default
    )
    private var completedTasks: FetchedResults<Task>

    @State private var taskPendingDelete: Task?

    var body: some View {
        NavigationStack {
            Group {
                if completedTasks.isEmpty {
                    emptyState
                } else {
                    ScrollView {
                        LazyVStack(spacing: 10) {
                            ForEach(completedTasks) { task in
                                NavigationLink(destination: TaskDetailScreen(task: task)) {
                                    TaskCardView(task: task.toTaskItem())
                                }
                                .buttonStyle(.plain)
                                .contextMenu {
                                    Button {
                                        restore(task)
                                    } label: {
                                        Label("Restore", systemImage: "arrow.uturn.backward")
                                    }
                                    Button(role: .destructive) {
                                        taskPendingDelete = task
                                    } label: {
                                        Label("Delete Permanently", systemImage: "trash")
                                    }
                                }
                                .swipeActions(edge: .leading, allowsFullSwipe: true) {
                                    Button {
                                        restore(task)
                                    } label: {
                                        Label("Restore", systemImage: "arrow.uturn.backward")
                                    }
                                    .tint(.blue)
                                }
                                .swipeActions(edge: .trailing, allowsFullSwipe: false) {
                                    Button(role: .destructive) {
                                        taskPendingDelete = task
                                    } label: {
                                        Label("Delete", systemImage: "trash")
                                    }
                                }
                            }
                        }
                        .padding(.horizontal, 16)
                        .padding(.top, 8)
                    }
                }
            }
            .background(Color(.systemGroupedBackground))
            .navigationTitle("Completed Tasks")
            .navigationBarTitleDisplayMode(.inline)
            .alert(
                "Delete Permanently?",
                isPresented: Binding(
                    get: { taskPendingDelete != nil },
                    set: { if !$0 { taskPendingDelete = nil } }
                ),
                presenting: taskPendingDelete
            ) { task in
                Button("Cancel", role: .cancel) { }
                Button("Delete", role: .destructive) { deletePermanently(task) }
            } message: { _ in
                Text("This will remove the task from the app permanently.")
            }
        }
    }

    private var emptyState: some View {
        VStack(spacing: 12) {
            Image(systemName: "checkmark.seal")
                .font(.system(size: 56))
                .foregroundColor(.secondary)
            Text("No Completed Tasks")
                .font(.title3)
                .fontWeight(.semibold)
            Text("Tasks you mark as complete will appear here.")
                .font(.subheadline)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 32)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }

    private func restore(_ task: Task) {
        task.isCompleted = false
        saveContext()
    }

    private func deletePermanently(_ task: Task) {
        viewContext.delete(task)
        saveContext()
        taskPendingDelete = nil
    }

    private func saveContext() {
        do {
            try viewContext.save()
        } catch {
            print("Error saving context: \(error.localizedDescription)")
        }
    }
}

#Preview {
    CompletedTasksScreen()
        .environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
}
