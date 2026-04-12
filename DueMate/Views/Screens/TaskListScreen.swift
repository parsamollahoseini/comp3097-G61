import SwiftUI
import CoreData

struct TaskListScreen: View {
    @Environment(\.managedObjectContext) private var viewContext

    // Core Data: Fetch all tasks that are not completed, sorted by due date
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Task.dueDate, ascending: true)],
        predicate: NSPredicate(format: "isCompleted == %@", NSNumber(value: false)),
        animation: .default
    )
    private var tasks: FetchedResults<Task>

    @State private var showAddTask = false
    @State private var searchText = ""
    @State private var selectedCategory: String? = nil
    @State private var selectedPriority: String? = nil
    @State private var sortOption: SortOption = .dueDate
    @State private var showFilters = false

    enum SortOption: String, CaseIterable {
        case dueDate = "Due Date"
        case priority = "Priority"
        case category = "Category"
        case title = "Title"
    }

    var filteredTasks: [Task] {
        var result = Array(tasks)

        // Search filter
        if !searchText.isEmpty {
            result = result.filter { task in
                (task.title ?? "").localizedCaseInsensitiveContains(searchText)
            }
        }

        // Category filter
        if let category = selectedCategory {
            result = result.filter { $0.category == category }
        }

        // Priority filter
        if let priority = selectedPriority {
            result = result.filter { $0.priority == priority }
        }

        // Sorting
        switch sortOption {
        case .dueDate:
            result.sort { ($0.dueDate ?? Date()) < ($1.dueDate ?? Date()) }
        case .priority:
            let priorityOrder = ["High": 0, "Medium": 1, "Low": 2]
            result.sort {
                priorityOrder[$0.priority ?? "Medium", default: 1] < priorityOrder[$1.priority ?? "Medium", default: 1]
            }
        case .category:
            result.sort { ($0.category ?? "") < ($1.category ?? "") }
        case .title:
            result.sort { ($0.title ?? "") < ($1.title ?? "") }
        }

        return result
    }

    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                // Filter chips
                if selectedCategory != nil || selectedPriority != nil {
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 8) {
                            if let category = selectedCategory {
                                FilterChip(title: category) {
                                    selectedCategory = nil
                                }
                            }
                            if let priority = selectedPriority {
                                FilterChip(title: priority) {
                                    selectedPriority = nil
                                }
                            }
                        }
                        .padding(.horizontal, 16)
                        .padding(.vertical, 8)
                    }
                    .background(Color(.systemGroupedBackground))
                }

                ScrollView {
                    LazyVStack(spacing: 10) {
                        // Core Data: Iterate through filtered tasks
                        ForEach(filteredTasks, id: \.id) { task in
                            NavigationLink(destination: TaskDetailScreenWrapper(task: task)) {
                                TaskCardViewWrapper(task: task)
                            }
                            .buttonStyle(.plain)
                            .swipeActions(edge: .trailing, allowsFullSwipe: true) {
                                Button {
                                    completeTask(task)
                                } label: {
                                    Label("Complete", systemImage: "checkmark")
                                }
                                .tint(.green)
                            }
                            .swipeActions(edge: .trailing, allowsFullSwipe: false) {
                                Button(role: .destructive) {
                                    deleteTask(task)
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
            .background(Color(.systemGroupedBackground))
            .navigationTitle("My Tasks")
            .navigationBarTitleDisplayMode(.inline)
            .searchable(text: $searchText, prompt: "Search tasks")
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Menu {
                        Picker("Sort By", selection: $sortOption) {
                            ForEach(SortOption.allCases, id: \.self) { option in
                                Text(option.rawValue).tag(option)
                            }
                        }

                        Divider()

                        Menu("Category") {
                            Button("All") { selectedCategory = nil }
                            ForEach(TaskCategory.allCases) { category in
                                Button(category.rawValue) {
                                    selectedCategory = category.rawValue
                                }
                            }
                        }

                        Menu("Priority") {
                            Button("All") { selectedPriority = nil }
                            ForEach(TaskPriority.allCases) { priority in
                                Button(priority.rawValue) {
                                    selectedPriority = priority.rawValue
                                }
                            }
                        }
                    } label: {
                        Image(systemName: "line.3.horizontal.decrease.circle")
                            .fontWeight(.semibold)
                    }
                    .tint(.orange)
                }

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

    private func completeTask(_ task: Task) {
        task.isCompleted = true
        saveContext()
    }

    private func deleteTask(_ task: Task) {
        viewContext.delete(task)
        saveContext()
    }

    private func saveContext() {
        do {
            try viewContext.save()
        } catch {
            print("Error saving context: \(error.localizedDescription)")
        }
    }
}

// Filter Chip View
struct FilterChip: View {
    let title: String
    let onRemove: () -> Void

    var body: some View {
        HStack(spacing: 4) {
            Text(title)
                .font(.caption)
                .fontWeight(.medium)
            Button {
                onRemove()
            } label: {
                Image(systemName: "xmark.circle.fill")
                    .font(.caption)
            }
        }
        .padding(.horizontal, 10)
        .padding(.vertical, 6)
        .background(Color.orange.opacity(0.2))
        .foregroundColor(.orange)
        .cornerRadius(16)
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
        TaskDetailScreen(task: task)
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
