import SwiftUI
import CoreData

struct StatisticsView: View {
    @Environment(\.managedObjectContext) private var viewContext

    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Task.createdAt, ascending: false)],
        animation: .default
    )
    private var allTasks: FetchedResults<Task>

    var completedTasks: [Task] {
        allTasks.filter { $0.isCompleted }
    }

    var activeTasks: [Task] {
        allTasks.filter { !$0.isCompleted }
    }

    var overdueTasks: [Task] {
        activeTasks.filter { ($0.dueDate ?? Date()) < Date() }
    }

    var completionRate: Double {
        guard !allTasks.isEmpty else { return 0 }
        return Double(completedTasks.count) / Double(allTasks.count) * 100
    }

    var tasksByCategory: [String: Int] {
        var categoryCount: [String: Int] = [:]
        for task in allTasks {
            let category = task.category ?? "Personal"
            categoryCount[category, default: 0] += 1
        }
        return categoryCount
    }

    var tasksByPriority: [String: Int] {
        var priorityCount: [String: Int] = [:]
        for task in allTasks {
            let priority = task.priority ?? "Medium"
            priorityCount[priority, default: 0] += 1
        }
        return priorityCount
    }

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 24) {
                    // Overview Stats
                    VStack(alignment: .leading, spacing: 16) {
                        Text("Overview")
                            .font(.headline)
                            .padding(.horizontal, 16)

                        LazyVGrid(columns: [
                            GridItem(.flexible()),
                            GridItem(.flexible())
                        ], spacing: 12) {
                            StatsCard(
                                title: "Total Tasks",
                                value: "\(allTasks.count)",
                                icon: "list.bullet",
                                color: .blue
                            )

                            StatsCard(
                                title: "Completed",
                                value: "\(completedTasks.count)",
                                icon: "checkmark.circle.fill",
                                color: .green
                            )

                            StatsCard(
                                title: "Active",
                                value: "\(activeTasks.count)",
                                icon: "clock.fill",
                                color: .orange
                            )

                            StatsCard(
                                title: "Overdue",
                                value: "\(overdueTasks.count)",
                                icon: "exclamationmark.triangle.fill",
                                color: .red
                            )
                        }
                        .padding(.horizontal, 16)
                    }

                    // Completion Rate
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Completion Rate")
                            .font(.headline)
                            .padding(.horizontal, 16)

                        VStack(spacing: 8) {
                            HStack {
                                Text("\(Int(completionRate))%")
                                    .font(.system(size: 48, weight: .bold))
                                    .foregroundColor(.green)
                                Spacer()
                            }

                            GeometryReader { geometry in
                                ZStack(alignment: .leading) {
                                    Rectangle()
                                        .fill(Color(.systemGray5))
                                        .frame(height: 12)
                                        .cornerRadius(6)

                                    Rectangle()
                                        .fill(Color.green)
                                        .frame(width: geometry.size.width * (completionRate / 100), height: 12)
                                        .cornerRadius(6)
                                }
                            }
                            .frame(height: 12)

                            HStack {
                                Text("\(completedTasks.count) of \(allTasks.count) tasks completed")
                                    .font(.caption)
                                    .foregroundColor(.secondary)
                                Spacer()
                            }
                        }
                        .padding(16)
                        .background(Color(.systemBackground))
                        .cornerRadius(12)
                        .shadow(color: Color.black.opacity(0.04), radius: 4, x: 0, y: 2)
                        .padding(.horizontal, 16)
                    }

                    // Tasks by Category
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Tasks by Category")
                            .font(.headline)
                            .padding(.horizontal, 16)

                        VStack(spacing: 12) {
                            ForEach(Array(tasksByCategory.sorted(by: { $0.value > $1.value })), id: \.key) { category, count in
                                HStack {
                                    Circle()
                                        .fill(colorForCategory(category))
                                        .frame(width: 12, height: 12)
                                    Text(category)
                                        .font(.subheadline)
                                    Spacer()
                                    Text("\(count)")
                                        .font(.subheadline)
                                        .fontWeight(.semibold)
                                }
                            }
                        }
                        .padding(16)
                        .background(Color(.systemBackground))
                        .cornerRadius(12)
                        .shadow(color: Color.black.opacity(0.04), radius: 4, x: 0, y: 2)
                        .padding(.horizontal, 16)
                    }

                    // Tasks by Priority
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Tasks by Priority")
                            .font(.headline)
                            .padding(.horizontal, 16)

                        VStack(spacing: 12) {
                            ForEach(["High", "Medium", "Low"], id: \.self) { priority in
                                if let count = tasksByPriority[priority], count > 0 {
                                    HStack {
                                        Circle()
                                            .fill(colorForPriority(priority))
                                            .frame(width: 12, height: 12)
                                        Text(priority)
                                            .font(.subheadline)
                                        Spacer()
                                        Text("\(count)")
                                            .font(.subheadline)
                                            .fontWeight(.semibold)
                                    }
                                }
                            }
                        }
                        .padding(16)
                        .background(Color(.systemBackground))
                        .cornerRadius(12)
                        .shadow(color: Color.black.opacity(0.04), radius: 4, x: 0, y: 2)
                        .padding(.horizontal, 16)
                    }
                }
                .padding(.vertical, 16)
            }
            .background(Color(.systemGroupedBackground))
            .navigationTitle("Statistics")
            .navigationBarTitleDisplayMode(.large)
        }
    }

    private func colorForCategory(_ category: String) -> Color {
        switch category {
        case "Work": return .blue
        case "School": return .purple
        case "Personal": return .green
        default: return .gray
        }
    }

    private func colorForPriority(_ priority: String) -> Color {
        switch priority {
        case "High": return .red
        case "Medium": return .orange
        case "Low": return .green
        default: return .gray
        }
    }
}

struct StatsCard: View {
    let title: String
    let value: String
    let icon: String
    let color: Color

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Image(systemName: icon)
                    .foregroundColor(color)
                Spacer()
            }
            Text(value)
                .font(.title)
                .fontWeight(.bold)
            Text(title)
                .font(.caption)
                .foregroundColor(.secondary)
        }
        .padding(16)
        .background(Color(.systemBackground))
        .cornerRadius(12)
        .shadow(color: Color.black.opacity(0.04), radius: 4, x: 0, y: 2)
    }
}

#Preview {
    StatisticsView()
        .environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
}
