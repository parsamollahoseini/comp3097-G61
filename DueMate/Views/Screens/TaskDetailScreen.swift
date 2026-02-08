import SwiftUI

struct TaskDetailScreen: View {
    let task: TaskItem
    @Environment(\.dismiss) private var dismiss
    @State private var showEditTask = false
    
    private var statusLabel: String {
        task.status.rawValue
    }
    
    private var statusColor: Color {
        switch task.status {
        case .overdue: return .red
        case .dueSoon: return .orange
        case .upcoming: return .green
        case .completed: return .green
        }
    }
    
    private var formattedDueDate: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "EEEE, MMMM d, yyyy 'at' h:mm a"
        return formatter.string(from: task.dueDate)
    }
    
    var body: some View {
        VStack(spacing: 0) {
            ScrollView {
                VStack(spacing: 12) {
                    // Task Title Card
                    cardView {
                        Text(task.title)
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
                                Image(systemName: task.status == .overdue ? "exclamationmark.circle" : "clock")
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
                            
                            Text(task.category.rawValue)
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
                            
                            Text(task.priority.rawValue)
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
                    // Milestone 1: placeholder action
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
                    // Milestone 1: placeholder action
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
            AddEditTaskScreen(mode: .edit(task))
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
}

#Preview {
    NavigationStack {
        TaskDetailScreen(task: TaskItem.sampleTasks[1])
    }
}
