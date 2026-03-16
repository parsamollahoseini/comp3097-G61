# Kevin's Implementation Tasks – AddTaskView (Add Task Feature)

**Branch name:** `kevin-add-task`

## Overview
You will implement the Core Data save functionality for **AddEditTaskScreen.swift**. The UI is already complete – you only need to add the Core Data logic to save new tasks.

## Your Responsibilities

### File You Own
- **DueMate/Views/Screens/AddEditTaskScreen.swift**

---

## 🚀 COMPLETE IMPLEMENTATION (Copy-Paste Ready)

### Step 1: Replace the ENTIRE AddEditTaskScreen.swift file

**Location:** `DueMate/Views/Screens/AddEditTaskScreen.swift`

**Copy this complete code:**

```swift
import SwiftUI
import CoreData

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
    @Environment(\.managedObjectContext) private var viewContext

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
                    saveTask()
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

    // MARK: - Core Data Save Function
    /// Saves the new task to Core Data
    private func saveTask() {
        // Create new Task entity in Core Data
        let newTask = Task(context: viewContext)
        newTask.id = UUID()
        newTask.title = taskTitle
        newTask.category = selectedCategory.rawValue
        newTask.dueDate = dueDate
        newTask.priority = selectedPriority.rawValue
        newTask.isCompleted = false
        newTask.createdAt = Date()

        // Save to Core Data
        do {
            try viewContext.save()
            print("✅ Task saved successfully: \(taskTitle)")
            dismiss()
        } catch {
            print("❌ Error saving task: \(error.localizedDescription)")
        }
    }
}

#Preview("New Task") {
    NavigationStack {
        AddEditTaskScreen(mode: .add)
            .environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}

#Preview("Edit Task") {
    NavigationStack {
        AddEditTaskScreen(mode: .edit(TaskItem.sampleTasks[1]))
            .environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}
```

---

## 📝 What Changed?

### Changes Made:
1. ✅ **Line 2:** Added `import CoreData`
2. ✅ **Line 18:** Added `@Environment(\.managedObjectContext) private var viewContext`
3. ✅ **Line 122:** Changed from `// Milestone 1: placeholder` to `saveTask()`
4. ✅ **Lines 175-195:** Added complete `saveTask()` function with Core Data logic
5. ✅ **Lines 199-210:** Updated previews to include Core Data context

### Key Implementation Details:
- Creates a new `Task` entity in Core Data context
- Sets all 7 required fields (id, title, category, dueDate, priority, isCompleted, createdAt)
- Saves using `viewContext.save()` with error handling
- Dismisses the view after successful save
- Includes debug print statements for testing

---

## ✅ Step-by-Step Instructions

### 1. Open Xcode Project
```bash
cd "/Users/parsamollahoseini/Documents/comp3097 project/DueMate"
open DueMate.xcodeproj
```

### 2. Locate the File
- In Xcode project navigator (left sidebar)
- Navigate to: **DueMate → Views → Screens → AddEditTaskScreen.swift**
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
- Select an iPhone simulator (e.g., iPhone 17)
- Press `Cmd+R` to run
- **Test Steps:**
  1. Tap the **+** button in the top-right
  2. Enter task title: "Test Task from Kevin"
  3. Select category: "Work"
  4. Set due date: Tomorrow
  5. Select priority: "High"
  6. Tap **Save Task**
  7. ✅ Task should appear in the list immediately
  8. Stop app (Cmd+.)
  9. Run app again (Cmd+R)
  10. ✅ Task should still be there (persistence verified!)

---

## Files You Should NOT Touch
- ❌ TaskListScreen.swift (Parsa's work)
- ❌ TaskDetailScreen.swift (Mehrad's work)
- ❌ PersistenceController.swift (Parsa's work)
- ❌ DueMate.xcdatamodeld (Parsa's work)
- ❌ DueMateApp.swift (Parsa's work)

## Branch & Merge Strategy

1. **Create your branch:**
   ```bash
   git checkout main
   git pull origin main
   git checkout -b kevin-add-task
   ```

2. **Make your changes** to AddEditTaskScreen.swift only

3. **Commit your work:**
   ```bash
   git add DueMate/Views/Screens/AddEditTaskScreen.swift
   git commit -m "Implement Add Task Core Data save functionality

   - Add Core Data context to AddEditTaskScreen
   - Implement save logic to create new Task entities
   - Tasks are now persisted to Core Data
   - Tested: Add task form saves and displays correctly

   ```

4. **Push your branch:**
   ```bash
   git push -u origin kevin-add-task
   ```

5. **Wait for Parsa's branch to merge first**, then update from main:
   ```bash
   git checkout main
   git pull origin main
   git checkout kevin-add-task
   git merge main
   ```

6. **Create a pull request** on GitHub targeting `main`

## Merge Order
1. ✅ Parsa merges first (Task List + Core Data setup)
2. ⏳ **YOU merge second** (Add Task functionality)
3. ⏳ Mehrad merges last (Task Detail functionality)

## Questions?
- Check PersistenceController.swift to see how Core Data is set up
- Check TaskListScreen.swift to see how Core Data fetch works
- The Task entity has these fields:
  - id: UUID
  - title: String
  - category: String
  - dueDate: Date
  - priority: String
  - isCompleted: Bool
  - createdAt: Date

## Success Criteria
✅ You can add a new task via the form
✅ The task appears immediately in the task list
✅ The task persists after closing and reopening the app
✅ No compile errors
✅ No runtime crashes
