import SwiftUI

struct SettingsScreen: View {
    var body: some View {
        NavigationStack {
            List {
                NavigationLink(destination: SettingsDetailScreen(title: "Notifications")) {
                    Label("Notifications", systemImage: "bell")
                }
                
                NavigationLink(destination: SettingsDetailScreen(title: "Account Settings")) {
                    Label("Account Settings", systemImage: "person.circle")
                }
                
                NavigationLink(destination: SettingsDetailScreen(title: "About")) {
                    Label("About", systemImage: "info.circle")
                }
                
                NavigationLink(destination: SettingsDetailScreen(title: "Privacy Policy")) {
                    Label("Privacy Policy", systemImage: "lock.shield")
                }
            }
            .listStyle(.insetGrouped)
            .navigationTitle("Settings")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}

// MARK: - Settings Detail (Placeholder for Milestone 1)
struct SettingsDetailScreen: View {
    let title: String
    
    var body: some View {
        VStack(spacing: 16) {
            Image(systemName: "wrench.and.screwdriver")
                .font(.system(size: 48))
                .foregroundColor(.secondary)
            
            Text(title)
                .font(.title2)
                .fontWeight(.semibold)
            
            Text("Coming in a future milestone.")
                .font(.subheadline)
                .foregroundColor(.secondary)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color(.systemGroupedBackground))
        .navigationTitle(title)
        .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview {
    SettingsScreen()
}
