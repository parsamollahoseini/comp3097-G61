# 🚀 Quick Start Guide for Kevin & Mehrad

## Kevin - Add Task Feature

### What You Need to Do:
Replace **ONE file**: `DueMate/Views/Screens/AddEditTaskScreen.swift`

### Quick Steps:
1. Open Xcode project
2. Find `AddEditTaskScreen.swift` in project navigator
3. Copy the complete code from `handoff/kevin/KEVIN_TASKS.md`
4. Select All (Cmd+A), Delete, Paste (Cmd+V), Save (Cmd+S)
5. Build (Cmd+B) and Run (Cmd+R)
6. Test: Tap + button, fill form, save, verify task appears

### Branch: `kevin-add-task`
### Full Instructions: `handoff/kevin/KEVIN_TASKS.md`

---

## Mehrad - Task Detail Feature

### What You Need to Do:
Replace **ONE file**: `DueMate/Views/Screens/TaskDetailScreen.swift`

### Quick Steps:
1. Wait for Parsa AND Kevin to merge first
2. Open Xcode project
3. Find `TaskDetailScreen.swift` in project navigator
4. Copy the complete code from `handoff/mehrad/MEHRAD_TASKS.md`
5. Select All (Cmd+A), Delete, Paste (Cmd+V), Save (Cmd+S)
6. Build (Cmd+B) and Run (Cmd+R)
7. Test: Tap task, mark complete/delete, verify changes persist

### Branch: `mehrad-task-detail`
### Full Instructions: `handoff/mehrad/MEHRAD_TASKS.md`

---

## Merge Order (IMPORTANT!)

```
1st → Parsa (Core Data setup)
        ↓
2nd → Kevin (Add Task)
        ↓
3rd → Mehrad (Complete/Delete Task)
```

---

## What's Already Done

### Parsa Completed:
✅ Core Data model (Task entity with 7 fields)
✅ PersistenceController
✅ TaskListScreen fetches from Core Data
✅ App integration with Core Data context
✅ Navigation framework

### Kevin Needs to Complete:
🔄 Add Core Data save logic to AddEditTaskScreen
- Import CoreData
- Add @Environment managedObjectContext
- Implement saveTask() function
- Update previews

### Mehrad Needs to Complete:
🔄 Add Core Data update/delete logic to TaskDetailScreen
- Import CoreData
- Change to accept Task entity (not TaskItem)
- Add @Environment managedObjectContext
- Implement markTaskComplete() function
- Implement deleteTask() function
- Update previews

---

## File Ownership (Don't Touch Others' Files!)

| Developer | Your File | DON'T Touch |
|-----------|-----------|-------------|
| Parsa | TaskListScreen.swift, CoreData/* | AddEditTaskScreen.swift, TaskDetailScreen.swift |
| Kevin | AddEditTaskScreen.swift | TaskListScreen.swift, TaskDetailScreen.swift |
| Mehrad | TaskDetailScreen.swift | TaskListScreen.swift, AddEditTaskScreen.swift |

---

## Testing Checklist

### After Kevin's Implementation:
- [ ] Can add new task
- [ ] Task appears in list immediately
- [ ] Task persists after app restart
- [ ] Form validation works (can't save empty title)

### After Mehrad's Implementation:
- [ ] Can mark task complete
- [ ] Completed task disappears from main list
- [ ] Can delete task
- [ ] Deleted task doesn't reappear
- [ ] All changes persist after app restart

---

## Help / Questions?

### Kevin:
- Check: `/handoff/kevin/KEVIN_TASKS.md`
- Look at: `PersistenceController.swift` for Core Data setup
- Look at: `TaskListScreen.swift` for @FetchRequest example

### Mehrad:
- Check: `/handoff/mehrad/MEHRAD_TASKS.md`
- Look at: `TaskListScreen.swift` for wrapper example
- Look at: Kevin's AddEditTaskScreen.swift for Core Data save example

---

## Git Commands Quick Reference

### Create Branch:
```bash
git checkout main
git pull origin main
git checkout -b YOUR-BRANCH-NAME
```

### Commit Changes:
```bash
git add DueMate/Views/Screens/YOUR-FILE.swift
git commit -m "Your commit message

```

### Push Branch:
```bash
git push -u origin YOUR-BRANCH-NAME
```

### Update from Main (after others merge):
```bash
git checkout main
git pull origin main
git checkout YOUR-BRANCH-NAME
git merge main
```

---

## Success Criteria

### Kevin's Success:
✅ AddEditTaskScreen.swift has Core Data save logic
✅ Can create tasks that persist
✅ No build errors
✅ Tasks appear in TaskListScreen

### Mehrad's Success:
✅ TaskDetailScreen.swift has Core Data complete/delete logic
✅ Can mark tasks complete (they disappear from list)
✅ Can delete tasks (they're removed permanently)
✅ No build errors
✅ Changes persist after app restart

---

## 🎉 Final Result

After all three branches merge, the app will have:
- ✅ Core Data persistence
- ✅ View task list
- ✅ Add new tasks
- ✅ View task details
- ✅ Mark tasks complete
- ✅ Delete tasks
- ✅ All data persists across app launches

**Milestone Progress: 30% Complete** 🚀

---

## Emergency Contact

If you get stuck:
1. Check the detailed instructions in your handoff folder
2. Check if the project builds (Cmd+B)
3. Check console output for error messages
4. Verify you're modifying the correct file
5. Make sure Parsa's branch is merged first (for Kevin)
6. Make sure Parsa AND Kevin branches are merged (for Mehrad)

**Good luck!** 🎊
