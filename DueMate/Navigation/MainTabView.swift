import SwiftUI

struct MainTabView: View {
    @State private var selectedTab: Tab = .tasks
    
    enum Tab {
        case tasks
        case completed
        case settings
    }
    
    var body: some View {
        TabView(selection: $selectedTab) {
            TaskListScreen()
                .tabItem {
                    Label("Tasks", systemImage: "list.bullet")
                }
                .tag(Tab.tasks)
            
            CompletedTasksScreen()
                .tabItem {
                    Label("Completed", systemImage: "checkmark.circle")
                }
                .tag(Tab.completed)
            
            SettingsScreen()
                .tabItem {
                    Label("Settings", systemImage: "gearshape")
                }
                .tag(Tab.settings)
        }
        .tint(.orange)
    }
}

#Preview {
    MainTabView()
}
