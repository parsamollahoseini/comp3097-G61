# 📦 Complete Implementation Package for Kevin & Mehrad

## Overview

Parsa has implemented Core Data and the Task List. You each have **ONE file** to update with complete, working code provided below.

---

## 🎯 Kevin's Assignment

### File to Modify:
📄 `DueMate/Views/Screens/AddEditTaskScreen.swift`

### What the Code Does:
- Adds Core Data save functionality to the Add Task form
- When user taps "Save Task", creates a new Task entity in Core Data
- Task appears immediately in the task list
- Task persists after app restart

### Where to Get the Code:
**Full code with instructions:** `/handoff/kevin/KEVIN_TASKS.md`

### Key Changes in the Code:
```swift
import CoreData  // Line 2 - Import Core Data

@Environment(\.managedObjectContext) private var viewContext  // Line 18 - Get Core Data context

Button { saveTask() }  // Line 147 - Call save function

// Lines 186-207 - The save function
private func saveTask() {
    let newTask = Task(context: viewContext)
    newTask.id = UUID()
    newTask.title = taskTitle
    newTask.category = selectedCategory.rawValue
    newTask.dueDate = dueDate
    newTask.priority = selectedPriority.rawValue
    newTask.isCompleted = false
    newTask.createdAt = Date()

    do {
        try viewContext.save()
        dismiss()
    } catch {
        print("Error saving task: \(error.localizedDescription)")
    }
}
```

### How to Implement:
1. Open `KEVIN_TASKS.md` in `/handoff/kevin/`
2. Copy the **entire file code** (it's all ready to paste)
3. Open `AddEditTaskScreen.swift` in Xcode
4. Select All (Cmd+A), Delete, Paste, Save
5. Build & Test

### Test Plan:
```
✅ Tap + button
✅ Enter task title: "Kevin's Test Task"
✅ Select category: Work
✅ Set due date: Tomorrow
✅ Select priority: High
✅ Tap Save Task
✅ Task appears in list
✅ Close app, reopen
✅ Task still there (persistence works!)
```

---

## 🎯 Mehrad's Assignment

### File to Modify:
📄 `DueMate/Views/Screens/TaskDetailScreen.swift`

### What the Code Does:
- Updates TaskDetailScreen to work with Core Data Task entities
- "Mark as Completed" button sets isCompleted=true and saves to Core Data
- "Delete Task" button deletes the task from Core Data
- Both actions persist after app restart

### Where to Get the Code:
**Full code with instructions:** `/handoff/mehrad/MEHRAD_TASKS.md`

### Key Changes in the Code:
```swift
import CoreData  // Line 2 - Import Core Data

@ObservedObject var task: Task  // Line 5 - Accept Core Data entity (not TaskItem)
@Environment(\.managedObjectContext) private var viewContext  // Line 7 - Get Core Data context

// Lines 10-19 - Convert Core Data Task → TaskItem for UI
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

// All UI references change from task.* to taskItem.*
Text(taskItem.title)  // Line 50
Text(taskItem.category.rawValue)  // Line 103

// Lines 209-223 - Mark complete function
private func markTaskComplete() {
    task.isCompleted = true
    do {
        try viewContext.save()
        dismiss()
    } catch {
        print("Error marking task complete: \(error.localizedDescription)")
    }
}

// Lines 225-239 - Delete function
private func deleteTask() {
    viewContext.delete(task)
    do {
        try viewContext.save()
        dismiss()
    } catch {
        print("Error deleting task: \(error.localizedDescription)")
    }
}
```

### How to Implement:
1. **WAIT for Parsa AND Kevin to merge first!**
2. Open `MEHRAD_TASKS.md` in `/handoff/mehrad/`
3. Copy the **entire file code** (it's all ready to paste)
4. Open `TaskDetailScreen.swift` in Xcode
5. Select All (Cmd+A), Delete, Paste, Save
6. Build & Test

### Test Plan:
```
✅ Tap on any task in the list
✅ Task Detail screen opens
✅ Tap "Mark as Completed"
✅ Returns to list, task disappears (filtered out)
✅ Close app, reopen
✅ Task still completed (persistence works!)

✅ Tap on another task
✅ Tap "Delete Task"
✅ Returns to list, task disappears
✅ Close app, reopen
✅ Task still deleted (persistence works!)
```

---

## 📁 File Locations

```
DueMate/
├── DueMate/
│   ├── Views/
│   │   └── Screens/
│   │       ├── AddEditTaskScreen.swift  ← KEVIN'S FILE
│   │       └── TaskDetailScreen.swift   ← MEHRAD'S FILE
│   └── CoreData/  ← PARSA'S FILES (don't touch)
└── handoff/
    ├── kevin/
    │   └── KEVIN_TASKS.md        ← Complete code for Kevin
    ├── mehrad/
    │   └── MEHRAD_TASKS.md       ← Complete code for Mehrad
    ├── QUICK_START_GUIDE.md      ← This file
    └── TEAMMATE_SUMMARY.md       ← Quick overview
```

---

## 🔄 Implementation Order

```
┌─────────────────────────────────────┐
│  1. PARSA MERGES FIRST              │
│     - Core Data setup               │
│     - Task entity model             │
│     - TaskListScreen with @FetchRequest │
└─────────────────┬───────────────────┘
                  │
                  ▼
┌─────────────────────────────────────┐
│  2. KEVIN MERGES SECOND             │
│     - Add Task Core Data save       │
│     - Users can now add tasks       │
└─────────────────┬───────────────────┘
                  │
                  ▼
┌─────────────────────────────────────┐
│  3. MEHRAD MERGES LAST              │
│     - Complete/Delete functionality │
│     - Users can manage tasks        │
└─────────────────────────────────────┘
```

---

## ⚠️ Important Notes

### For Kevin:
- ✅ Your code is 100% complete in `KEVIN_TASKS.md`
- ✅ Just copy-paste the entire file
- ✅ No need to write any code yourself
- ✅ Test thoroughly before committing
- ❌ Don't touch TaskDetailScreen.swift (Mehrad's file)
- ❌ Don't touch TaskListScreen.swift (Parsa's file)

### For Mehrad:
- ✅ Your code is 100% complete in `MEHRAD_TASKS.md`
- ✅ Just copy-paste the entire file
- ✅ No need to write any code yourself
- ⚠️ **MUST wait for Kevin to merge first** (you need tasks to test with)
- ✅ Test thoroughly before committing
- ❌ Don't touch AddEditTaskScreen.swift (Kevin's file)
- ❌ Don't touch TaskListScreen.swift (Parsa's file)

---

## 🛠️ Quick Commands

### Kevin - Your Commands:
```bash
# After Parsa merges
git checkout main
git pull origin main
git checkout -b kevin-add-task

# Make your changes (copy-paste code from KEVIN_TASKS.md)

git add DueMate/Views/Screens/AddEditTaskScreen.swift
git commit -m "Implement Add Task Core Data save functionality

- Add Core Data context to AddEditTaskScreen
- Implement save logic to create new Task entities
- Tasks are now persisted to Core Data
- Tested: Add task form saves and displays correctly


git push -u origin kevin-add-task

# Then create pull request on GitHub
```

### Mehrad - Your Commands:
```bash
# After Kevin merges
git checkout main
git pull origin main
git checkout -b mehrad-task-detail

# Make your changes (copy-paste code from MEHRAD_TASKS.md)

git add DueMate/Views/Screens/TaskDetailScreen.swift
git commit -m "Implement Task Detail complete and delete functionality

- Update TaskDetailScreen to work with Core Data Task entity
- Implement mark complete logic with Core Data save
- Implement delete logic with Core Data delete
- Tasks can now be completed and deleted with persistence


git push -u origin mehrad-task-detail

# Then create pull request on GitHub
```

---

## 📊 What You're Building

### Before Your Work:
```
App State:
- Task List: Shows empty list (no sample data)
- Add Task: Opens form, but Save doesn't work
- Task Detail: Shows details, but buttons do nothing
```

### After Kevin's Work:
```
App State:
- Task List: Shows real tasks from Core Data
- Add Task: ✅ WORKS - Saves tasks to Core Data
- Task Detail: Shows details, but buttons do nothing (waiting for Mehrad)
```

### After Mehrad's Work:
```
App State:
- Task List: Shows real tasks from Core Data
- Add Task: ✅ WORKS - Saves tasks to Core Data
- Task Detail: ✅ WORKS - Complete and delete work
```

---

## 🎓 What to Show Your Professor

### Kevin Should Highlight:
1. Core Data save implementation in AddEditTaskScreen.swift lines 186-207
2. Environment variable for managed object context (line 18)
3. Creating Task entity with all 7 fields (lines 189-197)
4. Error handling with do-catch (lines 200-206)
5. Live demo: Add task, close app, reopen, task still there

### Mehrad Should Highlight:
1. Core Data Task entity integration (line 5)
2. Computed property converting Task → TaskItem (lines 10-19)
3. Mark complete implementation (lines 209-223)
4. Delete implementation (lines 225-239)
5. Live demo: Complete task (disappears), delete task (gone forever), reopen app (changes persist)

---

## ✅ Success Checklist

### Kevin's Checklist:
- [ ] Copied complete code from KEVIN_TASKS.md
- [ ] Pasted into AddEditTaskScreen.swift
- [ ] Saved file (Cmd+S)
- [ ] Build succeeded (Cmd+B)
- [ ] Tested add task - appears in list
- [ ] Tested persistence - survives app restart
- [ ] Committed changes to kevin-add-task branch
- [ ] Pushed branch to GitHub
- [ ] Created pull request
- [ ] PR merged to main

### Mehrad's Checklist:
- [ ] Waited for Parsa AND Kevin to merge
- [ ] Pulled latest main
- [ ] Copied complete code from MEHRAD_TASKS.md
- [ ] Pasted into TaskDetailScreen.swift
- [ ] Saved file (Cmd+S)
- [ ] Build succeeded (Cmd+B)
- [ ] Tested mark complete - task disappears
- [ ] Tested delete - task removed permanently
- [ ] Tested persistence - changes survive app restart
- [ ] Committed changes to mehrad-task-detail branch
- [ ] Pushed branch to GitHub
- [ ] Created pull request
- [ ] PR merged to main

---

## 🎉 Final Result

After all three branches merge:

```
✅ Core Data persistence working
✅ Task list fetches from database
✅ Add task saves to database
✅ Mark complete updates database
✅ Delete removes from database
✅ All actions persist across app launches
✅ Clean team collaboration
✅ No merge conflicts
✅ 30% milestone complete!
```

---

## 📞 Need Help?

### Kevin:
- **Detailed instructions:** `/handoff/kevin/KEVIN_TASKS.md`
- **Quick reference:** This file
- **Example to learn from:** `TaskListScreen.swift` (see how Parsa used @FetchRequest)

### Mehrad:
- **Detailed instructions:** `/handoff/mehrad/MEHRAD_TASKS.md`
- **Quick reference:** This file
- **Example to learn from:** Kevin's `AddEditTaskScreen.swift` (see how to save Core Data)

---

**Remember:** The code is 100% complete and ready to use. Just copy, paste, test, commit, and push! 🚀
