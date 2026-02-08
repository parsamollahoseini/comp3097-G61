import SwiftUI

struct CompletedTasksScreen: View {
    // Hardcoded sample data for Milestone 1
    private let completedTasks: [TaskItem] = TaskItem.sampleTasks.filter { $0.isCompleted }
    
    var body: some View {
        NavigationStack {
            ScrollView {
                LazyVStack(spacing: 10) {
                    ForEach(completedTasks) { task in
                        NavigationLink(destination: TaskDetailScreen(task: task)) {
                            TaskCardView(task: task)
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
}
