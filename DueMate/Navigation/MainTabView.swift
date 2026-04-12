import SwiftUI

struct MainTabView: View {
    @State private var selectedTab: Tab = .today

    enum Tab {
        case today
        case tasks
        case completed
        case statistics
        case settings
    }

    var body: some View {
        TabView(selection: $selectedTab) {
            TodayView()
                .tabItem {
                    Label("Today", systemImage: "calendar")
                }
                .tag(Tab.today)

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

            StatisticsView()
                .tabItem {
                    Label("Stats", systemImage: "chart.bar.fill")
                }
                .tag(Tab.statistics)

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
