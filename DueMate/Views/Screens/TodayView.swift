import SwiftUI
import CoreData

struct TodayView: View {
    @Environment(\.managedObjectContext) private var viewContext

    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Task.priority, ascending: false)],
        predicate: NSCompoundPredicate(andPredicateWithSubpredicates: [
            NSPredicate(format: "isCompleted == %@", NSNumber(value: false)),
            NSPredicate(format: "dueDate >= %@ AND dueDate < %@",
                       Calendar.current.startOfDay(for: Date()) as CVarArg,
                       Calendar.current.date(byAdding: .day, value: 1, to: Calendar.current.startOfDay(for: Date()))! as CVarArg)
        ]),
        animation: .default
    )
    private var todayTasks: FetchedResults<Task>

    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Task.dueDate, ascending: true)],
        predicate: NSCompoundPredicate(andPredicateWithSubpredicates: [
            NSPredicate(format: "isCompleted == %@", NSNumber(value: false)),
            NSPredicate(format: "dueDate < %@", Calendar.current.startOfDay(for: Date()) as CVarArg)
        ]),
        animation: .default
    )
    private var overdueTasks: FetchedResults<Task>

    var completedTodayCount: Int {
        let request: NSFetchRequest<Task> = Task.fetchRequest()
        request.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [
            NSPredicate(format: "isCompleted == %@", NSNumber(value: true)),
            NSPredicate(format: "dueDate >= %@ AND dueDate < %@",
                       Calendar.current.startOfDay(for: Date()) as CVarArg,
                       Calendar.current.date(byAdding: .day, value: 1, to: Calendar.current.startOfDay(for: Date()))! as CVarArg)
        ])
        return (try? viewContext.count(for: request)) ?? 0
    }

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 20) {
                    // Stats Card
                    statsCard

                    // Overdue Section
                    if !overdueTasks.isEmpty {
                        VStack(alignment: .leading, spacing: 12) {
                            HStack {
                                Image(systemName: "exclamationmark.triangle.fill")
                                    .foregroundColor(.red)
                                Text("Overdue (\(overdueTasks.count))")
                                    .font(.headline)
                                    .foregroundColor(.red)
                            }
                            .padding(.horizontal, 16)

                            ForEach(overdueTasks) { task in
                                NavigationLink(destination: TaskDetailScreen(task: task)) {
                                    TaskCardView(task: task.toTaskItem())
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
                            }
                            .padding(.horizontal, 16)
                        }
                    }

                    // Today's Tasks Section
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Today's Tasks (\(todayTasks.count))")
                            .font(.headline)
                            .padding(.horizontal, 16)

                        if todayTasks.isEmpty {
                            emptyState
                        } else {
                            ForEach(todayTasks) { task in
                                NavigationLink(destination: TaskDetailScreen(task: task)) {
                                    TaskCardView(task: task.toTaskItem())
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
                            }
                            .padding(.horizontal, 16)
                        }
                    }
                }
                .padding(.vertical, 16)
            }
            .background(Color(.systemGroupedBackground))
            .navigationTitle("Today")
            .navigationBarTitleDisplayMode(.large)
        }
    }

    private var statsCard: some View {
        HStack(spacing: 20) {
            StatBox(
                title: "Today",
                value: "\(todayTasks.count)",
                icon: "calendar",
                color: .blue
            )

            StatBox(
                title: "Completed",
                value: "\(completedTodayCount)",
                icon: "checkmark.circle.fill",
                color: .green
            )

            StatBox(
                title: "Overdue",
                value: "\(overdueTasks.count)",
                icon: "exclamationmark.circle.fill",
                color: .red
            )
        }
        .padding(.horizontal, 16)
    }

    private var emptyState: some View {
        VStack(spacing: 12) {
            Image(systemName: "checkmark.circle")
                .font(.system(size: 48))
                .foregroundColor(.green)
            Text("All caught up!")
                .font(.title3)
                .fontWeight(.semibold)
            Text("No tasks due today")
                .font(.subheadline)
                .foregroundColor(.secondary)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 40)
    }

    private func completeTask(_ task: Task) {
        task.isCompleted = true
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

struct StatBox: View {
    let title: String
    let value: String
    let icon: String
    let color: Color

    var body: some View {
        VStack(spacing: 8) {
            Image(systemName: icon)
                .font(.title2)
                .foregroundColor(color)
            Text(value)
                .font(.title)
                .fontWeight(.bold)
            Text(title)
                .font(.caption)
                .foregroundColor(.secondary)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 16)
        .background(Color(.systemBackground))
        .cornerRadius(12)
        .shadow(color: Color.black.opacity(0.04), radius: 4, x: 0, y: 2)
    }
}

#Preview {
    TodayView()
        .environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
}
