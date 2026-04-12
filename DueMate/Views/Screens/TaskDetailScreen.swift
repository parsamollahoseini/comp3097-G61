import SwiftUI
import CoreData

struct TaskDetailScreen: View {
    @ObservedObject var task: Task
    @Environment(\.dismiss) private var dismiss
    @Environment(\.managedObjectContext) private var viewContext
    @State private var showEditTask = false
    @State private var showDeleteConfirm = false

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

    private var statusLabel: String { taskItem.status.rawValue }

    private var statusColor: Color {
        switch taskItem.status {
        case .overdue: return .red
        case .dueSoon: return .orange
        case .upcoming: return .green
        case .completed: return .green
        }
    }

    private var priorityColor: Color {
        switch taskItem.priority {
        case .high: return .red
        case .medium: return .orange
        case .low: return .blue
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
                    cardView {
                        Text(taskItem.title)
                            .font(.title2)
                            .fontWeight(.bold)
                            .strikethrough(taskItem.isCompleted)
                            .frame(maxWidth: .infinity, alignment: .leading)
                    }

                    cardView {
                        VStack(alignment: .leading, spacing: 6) {
                            Text("STATUS")
                                .font(.caption)
                                .fontWeight(.semibold)
                                .foregroundColor(.secondary)

                            HStack(spacing: 6) {
                                Image(systemName: taskItem.status == .overdue ? "exclamationmark.circle" : (taskItem.status == .completed ? "checkmark.circle.fill" : "clock"))
                                    .foregroundColor(statusColor)
                                Text(statusLabel)
                                    .foregroundColor(statusColor)
                                    .fontWeight(.medium)
                            }
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                    }

                    cardView {
                        VStack(alignment: .leading, spacing: 6) {
                            Text("CATEGORY")
                                .font(.caption)
                                .fontWeight(.semibold)
                                .foregroundColor(.secondary)
                            Text(taskItem.category.rawValue).font(.body)
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                    }

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
                                .background(priorityColor)
                                .cornerRadius(6)
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                    }
                }
                .padding(16)
            }

            VStack(spacing: 10) {
                Button {
                    toggleCompletion()
                } label: {
                    HStack {
                        Image(systemName: taskItem.isCompleted ? "arrow.uturn.backward.circle" : "checkmark.circle")
                        Text(taskItem.isCompleted ? "Restore Task" : "Mark as Completed")
                    }
                    .fontWeight(.semibold)
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 14)
                    .background(taskItem.isCompleted ? Color.blue : Color(.darkGray))
                    .cornerRadius(12)
                }

                Button {
                    showDeleteConfirm = true
                } label: {
                    HStack {
                        Image(systemName: "trash")
                        Text("Delete Task")
                    }
                    .fontWeight(.medium)
                    .foregroundColor(.red)
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
        .alert("Delete Task?", isPresented: $showDeleteConfirm) {
            Button("Cancel", role: .cancel) { }
            Button("Delete", role: .destructive) { deleteTask() }
        } message: {
            Text("This will permanently delete the task.")
        }
    }

    @ViewBuilder
    private func cardView<Content: View>(@ViewBuilder content: () -> Content) -> some View {
        content()
            .padding(16)
            .background(Color(.systemBackground))
            .cornerRadius(10)
            .shadow(color: Color.black.opacity(0.03), radius: 3, x: 0, y: 1)
    }

    private func toggleCompletion() {
        task.isCompleted.toggle()
        do {
            try viewContext.save()
            dismiss()
        } catch {
            print("Error updating task: \(error.localizedDescription)")
        }
    }

    private func deleteTask() {
        viewContext.delete(task)
        do {
            try viewContext.save()
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
