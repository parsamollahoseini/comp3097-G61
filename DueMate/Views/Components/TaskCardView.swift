import SwiftUI

struct TaskCardView: View {
    let task: TaskItem
    
    private var statusIcon: String {
        switch task.status {
        case .overdue: return "exclamationmark.circle"
        case .dueSoon: return "clock"
        case .upcoming: return ""
        case .completed: return "checkmark.circle"
        }
    }
    
    private var statusColor: Color {
        switch task.status {
        case .overdue: return .red
        case .dueSoon: return .orange
        case .upcoming: return .gray
        case .completed: return .green
        }
    }
    
    private var dueDateText: String {
        let formatter = DateFormatter()
        let calendar = Calendar.current
        
        if calendar.isDateInToday(task.dueDate) {
            formatter.dateFormat = "'Today,' h:mm a"
        } else if calendar.isDateInTomorrow(task.dueDate) {
            formatter.dateFormat = "'Tomorrow,' h:mm a"
        } else {
            formatter.dateFormat = "MMM d, h:mm a"
        }
        
        return formatter.string(from: task.dueDate)
    }
    
    var body: some View {
        HStack(alignment: .top) {
            // Left accent bar
            RoundedRectangle(cornerRadius: 2)
                .fill(task.status == .overdue ? Color.red.opacity(0.5) : (task.status == .dueSoon ? Color.orange.opacity(0.5) : Color.clear))
                .frame(width: 4)
                .padding(.vertical, 4)
            
            VStack(alignment: .leading, spacing: 6) {
                Text(task.title)
                    .font(.system(size: 16, weight: .medium))
                    .foregroundColor(task.isCompleted ? .secondary : .primary)
                    .strikethrough(task.isCompleted)
                
                HStack(spacing: 8) {
                    // Category badge
                    Text(task.category.rawValue)
                        .font(.caption2)
                        .fontWeight(.medium)
                        .padding(.horizontal, 8)
                        .padding(.vertical, 3)
                        .background(Color(.systemGray5))
                        .cornerRadius(4)
                    
                    // Due date
                    Text(dueDateText)
                        .font(.caption)
                        .foregroundColor(task.status == .overdue || task.status == .dueSoon ? statusColor : .secondary)
                        .strikethrough(task.isCompleted)
                }
            }
            
            Spacer()
            
            // Status icon
            if !statusIcon.isEmpty {
                Image(systemName: statusIcon)
                    .foregroundColor(statusColor)
                    .font(.system(size: 20))
                    .padding(.top, 4)
            }
        }
        .padding(12)
        .background(Color(.systemBackground))
        .cornerRadius(10)
        .shadow(color: Color.black.opacity(0.04), radius: 4, x: 0, y: 2)
    }
}

#Preview {
    VStack(spacing: 12) {
        TaskCardView(task: TaskItem.sampleTasks[0])
        TaskCardView(task: TaskItem.sampleTasks[4])
    }
    .padding()
    .background(Color(.systemGroupedBackground))
}
