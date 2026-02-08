import SwiftUI

struct TaskListScreen: View {
    // Hardcoded sample data for Milestone 1
    private let tasks: [TaskItem] = TaskItem.sampleTasks.filter { !$0.isCompleted }
    
    @State private var showAddTask = false
    
    var body: some View {
        NavigationStack {
            ScrollView {
                LazyVStack(spacing: 10) {
                    ForEach(tasks) { task in
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

#Preview {
    TaskListScreen()
}
