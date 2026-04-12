import SwiftUI
import CoreData

enum TaskSortOrder: String, CaseIterable, Identifiable {
    case dueDate = "Due Date"
    case priority = "Priority"
    var id: String { rawValue }
}

struct SettingsScreen: View {
    @Environment(\.managedObjectContext) private var viewContext
    @AppStorage("taskSortOrder") private var sortOrderRaw: String = TaskSortOrder.dueDate.rawValue

    @State private var showClearConfirm = false
    @State private var clearResultMessage: String?
    @State private var showClearResult = false

    private var sortOrder: Binding<TaskSortOrder> {
        Binding(
            get: { TaskSortOrder(rawValue: sortOrderRaw) ?? .dueDate },
            set: { sortOrderRaw = $0.rawValue }
        )
    }

    var body: some View {
        NavigationStack {
            List {
                Section("Sort Tasks By") {
                    Picker("Sort Order", selection: sortOrder) {
                        ForEach(TaskSortOrder.allCases) { order in
                            Text(order.rawValue).tag(order)
                        }
                    }
                    .pickerStyle(.segmented)
                }

                Section("Manage Completed") {
                    Button(role: .destructive) {
                        showClearConfirm = true
                    } label: {
                        Label("Clear All Completed Tasks", systemImage: "trash")
                    }
                }

                Section("About") {
                    HStack {
                        Label("App", systemImage: "app.badge")
                        Spacer()
                        Text("DueMate").foregroundColor(.secondary)
                    }
                    HStack {
                        Label("Version", systemImage: "number")
                        Spacer()
                        Text(appVersion).foregroundColor(.secondary)
                    }
                    HStack {
                        Label("Team", systemImage: "person.3")
                        Spacer()
                        Text("G61").foregroundColor(.secondary)
                    }
                }
            }
            .listStyle(.insetGrouped)
            .navigationTitle("Settings")
            .navigationBarTitleDisplayMode(.inline)
            .alert("Clear All Completed Tasks?", isPresented: $showClearConfirm) {
                Button("Cancel", role: .cancel) { }
                Button("Clear", role: .destructive) { clearAllCompleted() }
            } message: {
                Text("This permanently deletes every completed task. This cannot be undone.")
            }
            .alert("Done", isPresented: $showClearResult, presenting: clearResultMessage) { _ in
                Button("OK", role: .cancel) { }
            } message: { message in
                Text(message)
            }
        }
    }

    private var appVersion: String {
        let v = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "1.0"
        let b = Bundle.main.infoDictionary?["CFBundleVersion"] as? String ?? "1"
        return "\(v) (\(b))"
    }

    private func clearAllCompleted() {
        let request: NSFetchRequest<Task> = Task.fetchRequest()
        request.predicate = NSPredicate(format: "isCompleted == %@", NSNumber(value: true))
        do {
            let completed = try viewContext.fetch(request)
            let count = completed.count
            for task in completed { viewContext.delete(task) }
            try viewContext.save()
            clearResultMessage = count == 0 ? "No completed tasks to clear." : "Cleared \(count) completed task\(count == 1 ? "" : "s")."
            showClearResult = true
        } catch {
            clearResultMessage = "Error: \(error.localizedDescription)"
            showClearResult = true
        }
    }
}

#Preview {
    SettingsScreen()
        .environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
}
