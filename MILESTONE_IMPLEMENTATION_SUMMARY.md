# DueMate Prototype Milestone – Implementation Summary

**Date:** March 16, 2026
**Project:** COMP3097 Group 61 – DueMate Task Management App
**Milestone:** Early Prototype (30% Complete) with Core Data

---

## ✅ Implementation Complete

### Parsa's Contribution (COMPLETED)

**Branch:** `parsa-task-list-coredata`

#### Files Created:
- `DueMate/CoreData/DueMate.xcdatamodeld/` - Core Data model with Task entity
- `DueMate/CoreData/PersistenceController.swift` - Core Data stack management

#### Files Modified:
- `DueMate/App/DueMateApp.swift` - Integrated Core Data context
- `DueMate/Views/Screens/TaskListScreen.swift` - Converted to use Core Data with @FetchRequest
- `DueMate.xcodeproj/project.pbxproj` - Added Core Data files to Xcode project

#### Features Implemented:
✅ Core Data model with Task entity (7 fields)
✅ PersistenceController with shared and preview instances
✅ Core Data context injection in app entry point
✅ TaskListScreen fetches tasks from Core Data (not hardcoded)
✅ Tasks sorted by due date, filtered by completion status
✅ Navigation to Add Task and Task Detail screens
✅ Complete app builds successfully

---

## 🔄 Kevin's Work (PENDING)

**Branch:** `kevin-add-task`

**File to Modify:**
- `DueMate/Views/Screens/AddEditTaskScreen.swift`

**What to Implement:**
- Add Core Data context environment
- Implement save logic to create new Task entities
- Handle form validation and error cases

**Instructions:** See `/handoff/kevin/KEVIN_TASKS.md`

---

## 🔄 Mehrad's Work (PENDING)

**Branch:** `mehrad-task-detail`

**File to Modify:**
- `DueMate/Views/Screens/TaskDetailScreen.swift`

**What to Implement:**
- Update to accept Core Data Task entity
- Implement "Mark Complete" button logic
- Implement "Delete Task" button logic
- Update preview for Core Data

**Instructions:** See `/handoff/mehrad/MEHRAD_TASKS.md`

---

## 📁 Project Structure

```
DueMate/
├── DueMate/
│   ├── App/
│   │   └── DueMateApp.swift [MODIFIED - Parsa]
│   ├── Models/
│   │   └── TaskItem.swift [Existing - UI model]
│   ├── CoreData/ [NEW - Parsa]
│   │   ├── DueMate.xcdatamodeld/
│   │   └── PersistenceController.swift
│   ├── Navigation/
│   │   └── MainTabView.swift [Existing]
│   ├── Views/
│   │   ├── Screens/
│   │   │   ├── LaunchScreenView.swift [Existing]
│   │   │   ├── TaskListScreen.swift [MODIFIED - Parsa]
│   │   │   ├── AddEditTaskScreen.swift [Kevin to modify]
│   │   │   ├── TaskDetailScreen.swift [Mehrad to modify]
│   │   │   ├── CompletedTasksScreen.swift [Existing placeholder]
│   │   │   └── SettingsScreen.swift [Existing placeholder]
│   │   └── Components/
│   │       └── TaskCardView.swift [Existing]
│   └── Resources/
│       └── Assets.xcassets
├── handoff/
│   ├── kevin/
│   │   └── KEVIN_TASKS.md
│   └── mehrad/
│       └── MEHRAD_TASKS.md
├── DueMate.xcodeproj [MODIFIED - Parsa]
└── README.md [Existing]
```

---

## 🗂️ Core Data Schema

**Entity:** Task

| Attribute    | Type    | Optional | Default |
|--------------|---------|----------|---------|
| id           | UUID    | No       | -       |
| title        | String  | No       | -       |
| category     | String  | No       | -       |
| dueDate      | Date    | No       | -       |
| priority     | String  | No       | -       |
| isCompleted  | Bool    | No       | false   |
| createdAt    | Date    | No       | -       |

---

## 🔀 Branch & Merge Strategy

### Branch Names:
1. `parsa-task-list-coredata` (Parsa)
2. `kevin-add-task` (Kevin)
3. `mehrad-task-detail` (Mehrad)

### Merge Order:
1. **Parsa merges first** ← Provides Core Data foundation
2. **Kevin merges second** ← Builds on Core Data to add tasks
3. **Mehrad merges last** ← Builds on both to complete/delete tasks

### Why This Order?
- Parsa's branch contains Core Data setup that both Kevin and Mehrad need
- Kevin's add functionality is independent of Mehrad's detail functionality
- Mehrad merges last to avoid conflicts (works with existing Core Data entities)

---

## 🧪 Testing Checklist

### After Parsa's Merge:
- ✅ App builds and runs
- ✅ Task list is empty (no sample data)
- ✅ Navigation to Add Task screen works
- ✅ Navigation to Task Detail screen works (once tasks exist)

### After Kevin's Merge:
- ✅ Can add new tasks via the + button
- ✅ Tasks appear immediately in task list
- ✅ Tasks persist after app restart
- ✅ Form validation works

### After Mehrad's Merge:
- ✅ Can mark tasks complete
- ✅ Completed tasks disappear from main list
- ✅ Can delete tasks
- ✅ Deleted tasks don't reappear
- ✅ All actions persist after app restart

---

## 🚀 Next Steps

### For Parsa:
1. Create branch `parsa-task-list-coredata`
2. Commit all Core Data and TaskListScreen changes
3. Push branch to GitHub
4. Create pull request targeting `main`
5. Merge pull request
6. Notify Kevin and Mehrad to pull latest main

### For Kevin:
1. Wait for Parsa's merge
2. Pull latest main
3. Create branch `kevin-add-task`
4. Follow instructions in `/handoff/kevin/KEVIN_TASKS.md`
5. Test thoroughly
6. Push and create pull request
7. Merge after review
8. Notify Mehrad

### For Mehrad:
1. Wait for Parsa's AND Kevin's merges
2. Pull latest main
3. Create branch `mehrad-task-detail`
4. Follow instructions in `/handoff/mehrad/MEHRAD_TASKS.md`
5. Test thoroughly
6. Push and create pull request
7. Merge after review

---

## 📊 Milestone Completion

**Current Status:** ~30% Complete

### Completed Features:
- ✅ Core Data persistence
- ✅ Task entity model
- ✅ Task list display with real data
- ✅ Navigation framework
- ✅ Launch screen
- ✅ Tab bar navigation
- ✅ Task card UI component

### In Progress:
- 🔄 Add task functionality (Kevin)
- 🔄 Complete task functionality (Mehrad)
- 🔄 Delete task functionality (Mehrad)

### Future Features (Not Yet Started):
- ⏳ Edit task functionality
- ⏳ Task filtering
- ⏳ Completed tasks screen
- ⏳ Settings screen
- ⏳ Notifications
- ⏳ Task search
- ⏳ Categories customization

---

## 📝 Commit Message Templates

### For Parsa:
```
Set up Core Data and implement Task List with persistence

- Add Core Data model with Task entity (7 fields)
- Create PersistenceController for Core Data stack management
- Integrate Core Data context into app entry point
- Update TaskListScreen to fetch tasks from Core Data using @FetchRequest
- Add wrapper views to convert Core Data Task to TaskItem for UI
- Tasks are now persisted and fetched from local database


```

---

## 🔗 GitHub Repository
https://github.com/parsamollahoseini/comp3097-G61

---

## 👥 Team Members
- Parsa Molahosseini (Core Data + Task List)
- Kevin George buhein (Add Task)
- Mehrad Bayat (Task Detail)
