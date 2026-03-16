# 🎯 Milestone 2: Core Data Integration (30% Complete)

## Overview
This milestone implements persistent data storage using Core Data, replacing hardcoded sample data with a real database.

## What's New
- ✅ **Core Data Setup** – Full persistence layer with Task entity
- ✅ **Task List with Real Data** – Tasks fetched from Core Data, not hardcoded
- ✅ **Navigation Framework** – Routes to Add Task and Task Detail screens
- 🔄 **Add Task** – UI complete, Core Data save pending (Kevin)
- 🔄 **Task Detail** – UI complete, complete/delete logic pending (Mehrad)

## Features Implemented

### Parsa's Contribution
- Core Data model with Task entity (id, title, category, dueDate, priority, isCompleted, createdAt)
- PersistenceController for Core Data stack management
- TaskListScreen using @FetchRequest to fetch tasks
- App entry point integration with managed object context

### Kevin's Work (In Progress)
- Implement Core Data save logic in AddEditTaskScreen
- See `/handoff/kevin/KEVIN_TASKS.md` for instructions

### Mehrad's Work (In Progress)
- Implement mark complete and delete logic in TaskDetailScreen
- See `/handoff/mehrad/MEHRAD_TASKS.md` for instructions

## Branch Strategy

**Branches:**
1. `parsa-task-list-coredata` – Core Data setup + Task List (Parsa)
2. `kevin-add-task` – Add Task functionality (Kevin)
3. `mehrad-task-detail` – Complete/Delete functionality (Mehrad)

**Merge Order:**
1. Parsa → main (provides Core Data foundation)
2. Kevin → main (builds on Core Data to add tasks)
3. Mehrad → main (builds on both to complete/delete tasks)

## Testing

### After All Merges:
- [ ] Can add new tasks
- [ ] Tasks persist after app restart
- [ ] Can mark tasks complete
- [ ] Can delete tasks
- [ ] No crashes or data loss

## Tech Stack
- SwiftUI
- Core Data
- iOS 17.0+
- Xcode 15+

## Files Modified/Created

### Created:
- `DueMate/CoreData/DueMate.xcdatamodeld/`
- `DueMate/CoreData/PersistenceController.swift`
- `handoff/kevin/KEVIN_TASKS.md`
- `handoff/mehrad/MEHRAD_TASKS.md`

### Modified:
- `DueMate/App/DueMateApp.swift`
- `DueMate/Views/Screens/TaskListScreen.swift`
- `DueMate.xcodeproj/project.pbxproj`

## Running the Project

1. Open `DueMate.xcodeproj` in Xcode
2. Select an iPhone simulator
3. Press Cmd+R to build and run
4. App will launch with empty task list (no more sample data)
5. Add tasks using the + button (once Kevin's branch merges)

## Next Steps
- Complete Core Data save functionality (Kevin)
- Complete Core Data update/delete functionality (Mehrad)
- Implement task filtering
- Add notifications support

## Team
- **Parsa Molahosseini** – Core Data & Task List
- **Kevin George buhein** – Add Task Feature
- **Mehrad Bayat** – Task Detail Features

---

**Course:** COMP3097 – Mobile App Development II
**Group:** 61
**Milestone:** 2 of 5 (30% Complete)
