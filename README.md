# DueMate – Milestone 1 Complete Guide

## COMP3097 – Mobile App Development II | Group 61

**Team:** Parsa Molahosseini, Kevin George buhein, Mehrad Bayat

---

## 1) XCODE PROJECT CREATION

### Step-by-Step

1. **Open Xcode** → File → New → Project
2. **Template:** iOS → App
3. **Settings:**
   - Product Name: `DueMate`
   - Team: Your Apple ID (or "None" if no dev account)
   - Organization Identifier: `com.group61`
   - Bundle Identifier (auto): `com.group61.DueMate`
   - Interface: **SwiftUI**
   - Language: **Swift**
   - Storage: **None** (we'll add Core Data later if needed)
   - Uncheck: "Include Tests"
4. **Save** to your desired folder

### Post-Creation Settings
- Set **Minimum Deployment Target** to **iOS 17.0** (Project → General → Minimum Deployments)
- Run on **iPhone 15 Pro simulator** to verify the blank app launches

### Alternative: Use the Pre-Built Project
Instead of creating from scratch, **use the zip file provided**. Unzip it, then open `DueMate.xcodeproj` in Xcode. However, since auto-generated pbxproj files can sometimes have issues, the **recommended approach** is:

1. Create a new Xcode project with the settings above
2. Delete the default `ContentView.swift` file
3. Copy all `.swift` files from the provided zip into the matching folder structure
4. Copy the `Assets.xcassets` folder into `Resources/`
5. Build and run

---

## 2) FILE & FOLDER STRUCTURE

### Why Multiple Files?
Even for a milestone, **separate files** are the standard. Each screen gets its own file, making it easy to divide work among team members, find code quickly, and satisfy grading rubrics.

### Project Structure

```
DueMate/
├── DueMate.xcodeproj
├── .gitignore
├── README.md
└── DueMate/
    ├── App/
    │   └── DueMateApp.swift          ← App entry point
    ├── Models/
    │   └── TaskItem.swift            ← Data model + sample data
    ├── Navigation/
    │   └── MainTabView.swift         ← Tab bar (Tasks/Completed/Settings)
    ├── Views/
    │   ├── Screens/
    │   │   ├── LaunchScreenView.swift
    │   │   ├── TaskListScreen.swift
    │   │   ├── CompletedTasksScreen.swift
    │   │   ├── SettingsScreen.swift
    │   │   ├── TaskDetailScreen.swift
    │   │   └── AddEditTaskScreen.swift
    │   └── Components/
    │       └── TaskCardView.swift    ← Reusable task card
    └── Resources/
        └── Assets.xcassets/
            ├── AccentColor.colorset/
            └── AppIcon.appiconset/
```

---

## 3) SCREEN INVENTORY + NAVIGATION MAP

### Screen List

| # | Screen | Description |
|---|--------|-------------|
| 1 | **Launch Screen** | Displays "DueMate", "Smart Task Management", and team member names |
| 2 | **Task List** | Shows all active tasks with category badges, due dates, and overdue/due-soon icons |
| 3 | **Completed Tasks** | Shows completed tasks with strikethrough text and checkmark icons |
| 4 | **Settings** | List of options: Notifications, Account Settings, About, Privacy Policy |
| 5 | **Task Details** | Shows task name, status, category, due date, priority + "Mark as Completed" and "Delete Task" buttons |
| 6 | **Add/Edit Task** | Form with: Task Title, Category picker, Date/Time picker, Priority selector (Low/Medium/High), Save/Cancel buttons |

### Navigation Map

```
App Launch
    │
    ▼
[1. Launch Screen] ──(2 sec delay)──▶ [Tab Bar]
                                         │
                              ┌──────────┼──────────┐
                              ▼          ▼          ▼
                        [2. Tasks]  [3. Completed] [4. Settings]
                              │          │          │
                         tap task   tap task   tap row
                              ▼          ▼          ▼
                        [5. Task    [5. Task   [Settings
                         Details]    Details]   Detail
                              │                Placeholder]
                         ┌────┴────┐
                    edit btn   + btn
                         ▼         ▼
                    [6. Edit   [6. New
                     Task]      Task]
```

### Assumptions
- **Assumption:** The "+" button to add new tasks is placed in the navigation bar of the Task List screen (not shown explicitly in PDF mockups but implied by the Add Task screen's existence)
- **Assumption:** Settings sub-screens (Notifications, Account, About, Privacy) are placeholder screens for Milestone 1
- **Assumption:** Tapping a completed task also navigates to Task Details

---

## 4) SWIFTUI NAVIGATION IMPLEMENTATION

### Architecture Choices

- **TabView** for the bottom tab bar (Tasks, Completed, Settings) — matches PDF mockups exactly
- **NavigationStack** inside each tab for push navigation
- **NavigationLink** for task list → task detail transitions
- **navigationDestination** for programmatic navigation (add/edit screens)

### Navigation Flow Summary

| From | To | Trigger |
|------|----|---------|
| Launch Screen | Tab Bar | Automatic 2-second timer |
| Task List | Task Detail | Tap any task card |
| Task List | Add Task | Tap "+" toolbar button |
| Task Detail | Edit Task | Tap pencil toolbar icon |
| Completed Tasks | Task Detail | Tap any completed task |
| Settings | Settings Detail | Tap any settings row |

All navigation uses `NavigationStack` — no `UIKit` or storyboards involved.

---

## 5) CODE — ALL FILES

All SwiftUI code is included in the zip file. Here's a summary of each file:

### `DueMateApp.swift`
- `@main` entry point
- Shows `LaunchScreenView` for 2 seconds, then transitions to `MainTabView`

### `TaskItem.swift`
- `TaskItem` struct with: id, title, category, dueDate, priority, isCompleted
- Enums: `TaskPriority` (Low/Medium/High), `TaskCategory` (Work/School/Personal), `TaskStatus` (Overdue/Due Soon/Upcoming/Completed)
- Computed `status` property that calculates based on current date
- `sampleTasks` static array with 8 hardcoded tasks matching the PDF

### `MainTabView.swift`
- Three-tab `TabView`: Tasks, Completed, Settings
- Orange tint color to match the PDF accent

### `LaunchScreenView.swift`
- Centered "DueMate" title + "Smart Task Management" subtitle
- Team members at bottom — matches PDF page 3 exactly

### `TaskListScreen.swift`
- `NavigationStack` with "My Tasks" title
- `ScrollView` + `LazyVStack` of `TaskCardView` items
- `NavigationLink` to `TaskDetailScreen` for each task
- "+" button in toolbar navigates to `AddEditTaskScreen(mode: .add)`

### `CompletedTasksScreen.swift`
- Same structure as Task List but filtered to `isCompleted == true`
- Strikethrough styling on task titles and dates

### `SettingsScreen.swift`
- `List` with 4 `NavigationLink` rows: Notifications, Account Settings, About, Privacy Policy
- Each links to a `SettingsDetailScreen` placeholder

### `TaskDetailScreen.swift`
- Shows task title, status, category, due date, priority in card layout
- "Mark as Completed" (dark) and "Delete Task" (light) buttons at bottom
- Pencil icon in toolbar navigates to `AddEditTaskScreen(mode: .edit(task))`

### `AddEditTaskScreen.swift`
- Dual-mode: `.add` (title "New Task") or `.edit(task)` (title "Edit Task", pre-fills fields)
- Form fields: TextField for title, Picker for category, DatePicker for due date, segmented priority buttons
- "Save Task" (disabled when title empty) and "Cancel" buttons

### `TaskCardView.swift`
- Reusable card component showing task name, category badge, formatted due date, and status icon
- Color-coded: red for overdue, orange for due soon, green for completed

---

## 6) USING PDF DESIGNS IN XCODE

### Export PDF Pages as Images
1. Open the proposal PDF in Preview (macOS)
2. Go to File → Export
3. Format: PNG, Resolution: 150 DPI
4. Save each page as: `mockup-launch.png`, `mockup-tasklist.png`, etc.

### Store in Xcode
1. In Xcode, open `Assets.xcassets`
2. Right-click → New Image Set for each mockup
3. Drag the PNG into the 1x slot
4. Name them `mockup-launch`, `mockup-tasklist`, etc.

### Side-by-Side Preview
In any SwiftUI file, use the Canvas preview (Cmd+Option+P):
- Keep the PDF/PNG open in Preview on one side
- Keep the Xcode canvas on the other
- Compare layouts as you code

### Preview Tip
Add `#Preview` blocks at the bottom of every file (already included in all code files) so you can see live previews without running the simulator.

---

## 7) GIT & GITHUB SUBMISSION

### Initialize & Push

```bash
# Navigate to project root
cd /path/to/DueMate

# Initialize git
git init

# Add gitignore (already included in the zip)
# If starting fresh:
# curl -o .gitignore https://raw.githubusercontent.com/github/gitignore/main/Swift.gitignore

# Stage all files
git add .

# First commit
git commit -m "feat: Milestone 1 - app structure and navigation

- Add all 6 screens: Launch, Task List, Completed Tasks, Settings, Task Details, Add/Edit Task
- Implement TabView navigation with Tasks, Completed, Settings tabs
- Implement NavigationStack push navigation for task details and add/edit
- Add TaskItem model with sample data
- Add reusable TaskCardView component
- SwiftUI only, no storyboards
- iOS 17.0 minimum deployment target

Group 61: Parsa Molahosseini, Kevin George buhein, Mehrad Bayat"

# Create repo on GitHub (go to github.com → New Repository)
# Name: COMP3097-DueMate (or as required)
# Visibility: Private (or as required by professor)
# Do NOT initialize with README (we already have content)

# Add remote and push
git remote add origin https://github.com/YOUR_USERNAME/COMP3097-DueMate.git
git branch -M main
git push -u origin main
```

### Verify
- Go to your GitHub repo in browser
- Confirm all files are visible
- Confirm the `.xcodeproj` file is present
- Clone to a new location and open in Xcode to verify it builds

---

## 8) DEMO VIDEO CHECKLIST + SCRIPT

### Checklist (60–120 seconds)
- [ ] Show app launching (Launch Screen with team names)
- [ ] Show Task List tab with sample tasks
- [ ] Tap a task → show Task Details screen
- [ ] Tap edit icon → show Edit Task screen
- [ ] Go back → tap "+" → show New Task screen
- [ ] Switch to Completed tab → show completed tasks
- [ ] Switch to Settings tab → show settings list
- [ ] Tap a settings option → show placeholder detail

### Demo Script

> "Hi, this is Group 61 presenting DueMate — our Smart Task Management App for COMP3097.
>
> When the app launches, you see our launch screen with the app name and team members: Parsa, Kevin, and Mehrad.
>
> After loading, we land on the Task List screen showing all active tasks. Each task card displays the title, category, due date, and a visual indicator — orange clock for due soon, red exclamation for overdue.
>
> Tapping a task takes us to the Task Details screen where we see the full status, category, due date, and priority. There are buttons to mark as completed or delete — these will be functional in the next milestone.
>
> From here I can tap the edit icon to reach the Edit Task form, which pre-fills with the task's data. I can also go back and tap the plus button to create a new task from scratch.
>
> Switching to the Completed tab shows tasks that have been marked done, with strikethrough styling.
>
> Finally, the Settings tab has placeholder rows for Notifications, Account Settings, About, and Privacy Policy — these will be built out in future milestones.
>
> All navigation works end-to-end using SwiftUI's NavigationStack and TabView. No storyboards were used. That's our Milestone 1 progress — thank you."

### Recording Tips
- Use Xcode Simulator (Cmd+R) with iPhone 15 Pro
- Record with QuickTime (File → New Screen Recording) or OBS
- Keep it under 2 minutes
- Speak clearly and show every screen
