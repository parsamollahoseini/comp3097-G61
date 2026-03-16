# Mehrad's Implementation Tasks – TaskDetailView (Complete & Delete Features)

**Branch name:** `mehrad-task-detail`

## Overview
You will implement the Core Data update and delete functionality for **TaskDetailScreen.swift**. The UI is already complete – you only need to add the Core Data logic for marking tasks complete and deleting tasks.

## Your Responsibilities

### File You Own
- **DueMate/Views/Screens/TaskDetailScreen.swift**

---

## 🚀 COMPLETE IMPLEMENTATION (Copy-Paste Ready)

### Step 1: Replace the ENTIRE TaskDetailScreen.swift file

**Location:** `DueMate/Views/Screens/TaskDetailScreen.swift`

**Copy this complete code:**

```swift
import SwiftUI
import CoreData

struct TaskDetailScreen: View {
    @ObservedObject var task: Task
    @Environment(\.dismiss) private var dismiss
    @Environment(\.managedObjectContext) private var viewContext
    @State private var showEditTask = false

    // Convert Core Data Task to TaskItem for UI display
    private var taskItem: TaskItem {
        TaskItem(
            id: task.id ?? UUID(),
            title: task.title ?? "Untitled",
            category: TaskCategory(rawValue: task.category ?? "Personal") ?? .personal,
            dueDate: task.dueDate ?? Date(),
            priority: TaskPriority(rawValue: task.priority ?? "Medium") ?? .medium,
            isCompleted: task.isCompleted
        )
    }

    private var statusLabel: String {
        taskItem.status.rawValue
    }

    private var statusColor: Color {
        switch taskItem.status {
        case .overdue: return .red
        case .dueSoon: return .orange
        case .upcoming: return .green
        case .completed: return .green
        }
    }

    private var formattedDueDate: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "EEEE, MMMM d, yyyy 'at' h:mm a"
        return formatter.string(from: taskItem.dueDate)
    }

    var body: some View {
        VStack(spacing: 0) {
            ScrollView {
                VStack(spacing: 12) {
                    // Task Title Card
                    cardView {
                        Text(taskItem.title)
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
                                Image(systemName: taskItem.status == .overdue ? "exclamationmark.circle" : "clock")
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

                            Text(taskItem.category.rawValue)
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

                            Text(taskItem.priority.rawValue)
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
                    markTaskComplete()
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
                    deleteTask()
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
            AddEditTaskScreen(mode: .edit(taskItem))
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

    // MARK: - Core Data Mark Complete Function
    /// Marks the task as completed in Core Data
    private func markTaskComplete() {
        // Update task completion status
        task.isCompleted = true

        // Save to Core Data
        do {
            try viewContext.save()
            print("✅ Task marked complete: \(task.title ?? "Unknown")")
            dismiss()
        } catch {
            print("❌ Error marking task complete: \(error.localizedDescription)")
        }
    }

    // MARK: - Core Data Delete Function
    /// Deletes the task from Core Data
    private func deleteTask() {
        // Delete task from Core Data context
        viewContext.delete(task)

        // Save changes
        do {
            try viewContext.save()
            print("✅ Task deleted: \(task.title ?? "Unknown")")
            dismiss()
        } catch {
            print("❌ Error deleting task: \(error.localizedDescription)")
        }
    }
}

#Preview {
    let context = PersistenceController.preview.container.viewContext
    let task = Task(context: context)
    task.id = UUID()
    task.title = "Sample Task for Preview"
    task.category = "Work"
    task.dueDate = Date()
    task.priority = "High"
    task.isCompleted = false
    task.createdAt = Date()

    return NavigationStack {
        TaskDetailScreen(task: task)
            .environment(\.managedObjectContext, context)
    }
}
```

---

## 📝 What Changed?

### Changes Made:
1. ✅ **Line 2:** Added `import CoreData`
2. ✅ **Line 5:** Changed from `let task: TaskItem` to `@ObservedObject var task: Task`
3. ✅ **Line 7:** Added `@Environment(\.managedObjectContext) private var viewContext`
4. ✅ **Lines 10-19:** Added `taskItem` computed property to convert Core Data Task → TaskItem
5. ✅ **All UI references:** Changed from `task.*` to `taskItem.*` (lines 24, 33, 38, 50, 67, 82, 96, 113)
6. ✅ **Line 144:** Changed button action to `markTaskComplete()`
7. ✅ **Line 157:** Changed button action to `deleteTask()`
8. ✅ **Lines 204-218:** Added `markTaskComplete()` function with Core Data update logic
9. ✅ **Lines 220-234:** Added `deleteTask()` function with Core Data delete logic
10. ✅ **Lines 238-253:** Updated preview to work with Core Data

### Key Implementation Details:
- Accepts `@ObservedObject var task: Task` (Core Data entity)
- Converts to `TaskItem` for UI display using computed property
- `markTaskComplete()` sets `isCompleted = true` and saves
- `deleteTask()` calls `viewContext.delete(task)` and saves
- Both functions include error handling and debug prints
- TaskListScreen wrapper already passes Core Data Task entity

---

## ✅ Step-by-Step Instructions

### 1. Open Xcode Project
```bash
cd "/Users/parsamollahoseini/Documents/comp3097 project/DueMate"
open DueMate.xcodeproj
```

### 2. Locate the File
- In Xcode project navigator (left sidebar)
- Navigate to: **DueMate → Views → Screens → TaskDetailScreen.swift**
- Click to open the file

### 3. Replace the Content
- **Select All:** Press `Cmd+A`
- **Delete:** Press `Delete`
- **Paste:** Copy the complete code above and paste it (`Cmd+V`)
- **Save:** Press `Cmd+S`

### 4. Build the Project
- Press `Cmd+B` to build
- Should compile with no errors

### 5. Test Your Implementation

**Prerequisites:** You need tasks in the list first!
- If no tasks exist, ask Kevin to merge his branch first OR manually add tasks using his code

**Test Steps:**
1. Select an iPhone simulator (e.g., iPhone 17)
2. Press `Cmd+R` to run
3. **Test Mark Complete:**
   - Tap on any task in the list
   - Task Detail screen opens
   - Tap **"Mark as Completed"**
   - ✅ Should navigate back to list
   - ✅ Task should disappear from main list (filtered out)
   - Stop and restart app
   - ✅ Task should still be gone (persistence verified!)

4. **Test Delete:**
   - Tap on another task
   - Tap **"Delete Task"**
   - ✅ Should navigate back to list
   - ✅ Task should disappear completely
   - Stop and restart app
   - ✅ Task should still be deleted (persistence verified!)

### 6. Check Console Output
- Open Xcode console (Cmd+Shift+Y)
- Look for debug messages:
  - `✅ Task marked complete: [task name]`
  - `✅ Task deleted: [task name]`

## Files You Should NOT Touch
- ❌ TaskListScreen.swift (Parsa's work – but the wrapper is already set up for you)
- ❌ AddEditTaskScreen.swift (Kevin's work)
- ❌ PersistenceController.swift (Parsa's work)
- ❌ DueMate.xcdatamodeld (Parsa's work)
- ❌ DueMateApp.swift (Parsa's work)

## Branch & Merge Strategy

1. **Create your branch:**
   ```bash
   git checkout main
   git pull origin main
   git checkout -b mehrad-task-detail
   ```

2. **Make your changes** to TaskDetailScreen.swift only

3. **Commit your work:**
   ```bash
   git add DueMate/Views/Screens/TaskDetailScreen.swift
   git commit -m "Implement Task Detail complete and delete functionality

   - Update TaskDetailScreen to work with Core Data Task entity
   - Implement mark complete logic with Core Data save
   - Implement delete logic with Core Data delete
   - Tasks can now be completed and deleted with persistence

   ```

4. **Push your branch:**
   ```bash
   git push -u origin mehrad-task-detail
   ```

5. **Wait for Parsa's AND Kevin's branches to merge first**, then update from main:
   ```bash
   git checkout main
   git pull origin main
   git checkout mehrad-task-detail
   git merge main
   ```

6. **Create a pull request** on GitHub targeting `main`

## Merge Order
1. ✅ Parsa merges first (Task List + Core Data setup)
2. ✅ Kevin merges second (Add Task functionality)
3. ⏳ **YOU merge last** (Task Detail functionality)

## Questions?
- Check PersistenceController.swift to see how Core Data is set up
- Check TaskListScreen.swift to see the TaskDetailScreenWrapper that passes the Core Data entity
- The Task entity has these fields:
  - id: UUID
  - title: String
  - category: String
  - dueDate: Date
  - priority: String
  - isCompleted: Bool
  - createdAt: Date

## Success Criteria
✅ You can mark a task as completed
✅ Completed tasks disappear from the task list
✅ You can delete a task
✅ Deleted tasks disappear from the task list
✅ Changes persist after closing and reopening the app
✅ No compile errors
✅ No runtime crashes
