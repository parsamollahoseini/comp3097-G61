import SwiftUI
import CoreData

struct TaskDetailScreen: View {
    @ObservedObject var task: Task
    @Environment(\.dismiss) private var dismiss
    @Environment(\.managedObjectContext) private var viewContext
    @State private var showEditTask = false

    // Convert Core Data Task to TaskItem for UI display
    private var taskItem: TaskItem {
        TaskItem(
            id: task.id ?? UUID(),
            title: task.title ?? "Untitled",
            category: TaskCategory(rawValue: task.category ?? "Personal") ?? .personal,
            dueDate: task.dueDate ?? Date(),
            priority: TaskPriority(rawValue: task.priority ?? "Medium") ?? .medium,
            isCompleted: task.isCompleted
        )
    }

    private var statusLabel: String {
        taskItem.status.rawValue
    }

    private var statusColor: Color {
        switch taskItem.status {
        case .overdue: return .red
        case .dueSoon: return .orange
        case .upcoming: return .green
        case .completed: return .green
        }
    }

    private var formattedDueDate: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "EEEE, MMMM d, yyyy 'at' h:mm a"
        return formatter.string(from: taskItem.dueDate)
    }

    var body: some View {
        VStack(spacing: 0) {
            ScrollView {
                VStack(spacing: 12) {
                    // Task Title Card
                    cardView {
                        Text(taskItem.title)
                            .font(.title2)
                            .fontWeight(.bold)
                            .frame(maxWidth: .infinity, alignment: .leading)
                    }

                    // Status Card
                    cardView {
                        VStack(alignment: .leading, spacing: 6) {
                            Text("STATUS")
                                .font(.caption)
                                .fontWeight(.semibold)
                                .foregroundColor(.secondary)

                            HStack(spacing: 6) {
                                Image(systemName: taskItem.status == .overdue ? "exclamationmark.circle" : "clock")
                                    .foregroundColor(statusColor)
                                Text(statusLabel)
                                    .foregroundColor(statusColor)
                                    .fontWeight(.medium)
                            }
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                    }

                    // Category Card
                    cardView {
                        VStack(alignment: .leading, spacing: 6) {
                            Text("CATEGORY")
                                .font(.caption)
                                .fontWeight(.semibold)
                                .foregroundColor(.secondary)

                            Text(taskItem.category.rawValue)
                                .font(.body)
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                    }

                    // Due Date Card
                    cardView {
                        VStack(alignment: .leading, spacing: 6) {
                            Text("DUE DATE & TIME")
                                .font(.caption)
                                .fontWeight(.semibold)
                                .foregroundColor(.secondary)

                            Text(formattedDueDate)
                                .font(.body)
                                .foregroundColor(statusColor)
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                    }

                    // Priority Card
                    cardView {
                        VStack(alignment: .leading, spacing: 6) {
                            Text("PRIORITY")
                                .font(.caption)
                                .fontWeight(.semibold)
                                .foregroundColor(.secondary)

                            Text(taskItem.priority.rawValue)
                                .font(.caption)
                                .fontWeight(.bold)
                                .foregroundColor(.white)
                                .padding(.horizontal, 14)
                                .padding(.vertical, 6)
                                .background(Color(.systemGray))
                                .cornerRadius(6)
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                    }
                }
                .padding(16)
            }

            // Bottom Action Buttons
            VStack(spacing: 10) {
                Button {
                    markTaskComplete()
                } label: {
                    HStack {
                        Image(systemName: "checkmark.circle")
                        Text("Mark as Completed")
                    }
                    .fontWeight(.semibold)
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 14)
                    .background(Color(.darkGray))
                    .cornerRadius(12)
                }

                Button {
                    deleteTask()
                } label: {
                    HStack {
                        Image(systemName: "trash")
                        Text("Delete Task")
                    }
                    .fontWeight(.medium)
                    .foregroundColor(.primary)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 14)
                    .background(Color(.systemGray6))
                    .cornerRadius(12)
                }
            }
            .padding(16)
        }
        .background(Color(.systemGroupedBackground))
        .navigationTitle("Task Details")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button {
                    showEditTask = true
                } label: {
                    Image(systemName: "pencil")
                }
                .tint(.primary)
            }
        }
        .navigationDestination(isPresented: $showEditTask) {
            AddEditTaskScreen(mode: .edit(taskItem))
        }
    }

    // MARK: - Card helper
    @ViewBuilder
    private func cardView<Content: View>(@ViewBuilder content: () -> Content) -> some View {
        content()
            .padding(16)
            .background(Color(.systemBackground))
            .cornerRadius(10)
            .shadow(color: Color.black.opacity(0.03), radius: 3, x: 0, y: 1)
    }

    // MARK: - Core Data Mark Complete Function
    /// Marks the task as completed in Core Data
    private func markTaskComplete() {
        task.isCompleted = true

        do {
            try viewContext.save()
            print("Task marked complete: \(task.title ?? "Unknown")")
            dismiss()
        } catch {
            print("Error marking task complete: \(error.localizedDescription)")
        }
    }

    // MARK: - Core Data Delete Function
    /// Deletes the task from Core Data
    private func deleteTask() {
        viewContext.delete(task)

        do {
            try viewContext.save()
            print("Task deleted: \(task.title ?? "Unknown")")
            dismiss()
        } catch {
            print("Error deleting task: \(error.localizedDescription)")
        }
    }
}

#Preview {
    let context = PersistenceController.preview.container.viewContext
    let task = Task(context: context)
    task.id = UUID()
    task.title = "Sample Task for Preview"
    task.category = "Work"
    task.dueDate = Date()
    task.priority = "High"
    task.isCompleted = false
    task.createdAt = Date()

    return NavigationStack {
        TaskDetailScreen(task: task)
            .environment(\.managedObjectContext, context)
    }
}
