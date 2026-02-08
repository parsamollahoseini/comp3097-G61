import Foundation

// MARK: - Task Priority
enum TaskPriority: String, CaseIterable, Identifiable {
    case low = "Low"
    case medium = "Medium"
    case high = "High"
    
    var id: String { rawValue }
}

// MARK: - Task Category
enum TaskCategory: String, CaseIterable, Identifiable {
    case work = "Work"
    case school = "School"
    case personal = "Personal"
    
    var id: String { rawValue }
}

// MARK: - Task Status
enum TaskStatus: String {
    case overdue = "Overdue"
    case dueSoon = "Due Soon"
    case upcoming = "Upcoming"
    case completed = "Completed"
}

// MARK: - Task Model
struct TaskItem: Identifiable {
    let id: UUID
    var title: String
    var category: TaskCategory
    var dueDate: Date
    var priority: TaskPriority
    var isCompleted: Bool
    
    init(
        id: UUID = UUID(),
        title: String,
        category: TaskCategory,
        dueDate: Date,
        priority: TaskPriority,
        isCompleted: Bool = false
    ) {
        self.id = id
        self.title = title
        self.category = category
        self.dueDate = dueDate
        self.priority = priority
        self.isCompleted = isCompleted
    }
    
    var status: TaskStatus {
        if isCompleted { return .completed }
        if dueDate < Date() { return .overdue }
        if dueDate.timeIntervalSinceNow < 86400 { return .dueSoon }
        return .upcoming
    }
}

// MARK: - Sample Data
extension TaskItem {
    static let sampleTasks: [TaskItem] = [
        TaskItem(
            title: "Complete project proposal",
            category: .work,
            dueDate: Calendar.current.date(bySettingHour: 23, minute: 7, second: 0, of: Date())!,
            priority: .high
        ),
        TaskItem(
            title: "Study for midterm exam",
            category: .school,
            dueDate: Calendar.current.date(byAdding: .day, value: 1, to: Calendar.current.date(bySettingHour: 21, minute: 7, second: 0, of: Date())!)!,
            priority: .high
        ),
        TaskItem(
            title: "Buy groceries",
            category: .personal,
            dueDate: Calendar.current.date(byAdding: .day, value: 5, to: Date())!,
            priority: .low
        ),
        TaskItem(
            title: "Team meeting preparation",
            category: .work,
            dueDate: Calendar.current.date(bySettingHour: 19, minute: 7, second: 0, of: Date())!,
            priority: .medium
        ),
        TaskItem(
            title: "Submit assignment",
            category: .school,
            dueDate: Calendar.current.date(byAdding: .day, value: -2, to: Date())!,
            priority: .high
        ),
        TaskItem(
            title: "Review code changes",
            category: .work,
            dueDate: Calendar.current.date(byAdding: .day, value: 3, to: Date())!,
            priority: .medium
        ),
        TaskItem(
            title: "Complete project proposal",
            category: .work,
            dueDate: Calendar.current.date(bySettingHour: 23, minute: 7, second: 0, of: Date())!,
            priority: .high,
            isCompleted: true
        ),
        TaskItem(
            title: "Call dentist",
            category: .personal,
            dueDate: Calendar.current.date(byAdding: .day, value: -4, to: Date())!,
            priority: .low,
            isCompleted: true
        )
    ]
}
