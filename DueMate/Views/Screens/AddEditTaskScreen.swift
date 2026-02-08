import SwiftUI

struct AddEditTaskScreen: View {
    enum Mode {
        case add
        case edit(TaskItem)
        
        var title: String {
            switch self {
            case .add: return "New Task"
            case .edit: return "Edit Task"
            }
        }
    }
    
    let mode: Mode
    @Environment(\.dismiss) private var dismiss
    
    // Form state
    @State private var taskTitle: String = ""
    @State private var selectedCategory: TaskCategory = .personal
    @State private var dueDate: Date = Date()
    @State private var selectedPriority: TaskPriority = .medium
    
    var body: some View {
        VStack(spacing: 0) {
            ScrollView {
                VStack(spacing: 0) {
                    // Form Card
                    VStack(spacing: 0) {
                        // Task Title
                        VStack(alignment: .leading, spacing: 6) {
                            Text("TASK TITLE")
                                .font(.caption)
                                .fontWeight(.semibold)
                                .foregroundColor(.secondary)
                            
                            TextField("Enter task title", text: $taskTitle)
                                .font(.body)
                        }
                        .padding(16)
                        
                        Divider().padding(.leading, 16)
                        
                        // Category
                        VStack(alignment: .leading, spacing: 6) {
                            Text("CATEGORY")
                                .font(.caption)
                                .fontWeight(.semibold)
                                .foregroundColor(.secondary)
                            
                            Picker("Category", selection: $selectedCategory) {
                                ForEach(TaskCategory.allCases) { category in
                                    Text(category.rawValue).tag(category)
                                }
                            }
                            .pickerStyle(.menu)
                            .labelsHidden()
                            .frame(maxWidth: .infinity, alignment: .leading)
                        }
                        .padding(16)
                        
                        Divider().padding(.leading, 16)
                        
                        // Due Date & Time
                        VStack(alignment: .leading, spacing: 6) {
                            Text("DUE DATE & TIME")
                                .font(.caption)
                                .fontWeight(.semibold)
                                .foregroundColor(.secondary)
                            
                            DatePicker("", selection: $dueDate)
                                .labelsHidden()
                                .frame(maxWidth: .infinity, alignment: .leading)
                        }
                        .padding(16)
                        
                        Divider().padding(.leading, 16)
                        
                        // Priority
                        VStack(alignment: .leading, spacing: 10) {
                            Text("PRIORITY")
                                .font(.caption)
                                .fontWeight(.semibold)
                                .foregroundColor(.secondary)
                            
                            HStack(spacing: 10) {
                                ForEach(TaskPriority.allCases) { priority in
                                    Button {
                                        selectedPriority = priority
                                    } label: {
                                        Text(priority.rawValue)
                                            .font(.subheadline)
                                            .fontWeight(.medium)
                                            .frame(maxWidth: .infinity)
                                            .padding(.vertical, 10)
                                            .background(
                                                selectedPriority == priority
                                                    ? Color(.darkGray)
                                                    : Color(.systemGray6)
                                            )
                                            .foregroundColor(
                                                selectedPriority == priority ? .white : .primary
                                            )
                                            .cornerRadius(8)
                                    }
                                }
                            }
                        }
                        .padding(16)
                    }
                    .background(Color(.systemBackground))
                    .cornerRadius(12)
                    .shadow(color: Color.black.opacity(0.03), radius: 3, x: 0, y: 1)
                    .padding(16)
                }
            }
            
            // Bottom Buttons
            VStack(spacing: 10) {
                Button {
                    // Milestone 1: placeholder — save not implemented
                    dismiss()
                } label: {
                    Text("Save Task")
                        .fontWeight(.semibold)
                        .foregroundColor(taskTitle.isEmpty ? .secondary : .white)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 14)
                        .background(taskTitle.isEmpty ? Color(.systemGray4) : Color(.darkGray))
                        .cornerRadius(12)
                }
                .disabled(taskTitle.isEmpty)
                
                Button {
                    dismiss()
                } label: {
                    Text("Cancel")
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
        .navigationTitle(mode.title)
        .navigationBarTitleDisplayMode(.inline)
        .onAppear {
            if case .edit(let task) = mode {
                taskTitle = task.title
                selectedCategory = task.category
                dueDate = task.dueDate
                selectedPriority = task.priority
            }
        }
    }
}

#Preview("New Task") {
    NavigationStack {
        AddEditTaskScreen(mode: .add)
    }
}

#Preview("Edit Task") {
    NavigationStack {
        AddEditTaskScreen(mode: .edit(TaskItem.sampleTasks[1]))
    }
}
