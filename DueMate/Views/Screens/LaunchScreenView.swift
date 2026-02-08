import SwiftUI

struct LaunchScreenView: View {
    var body: some View {
        VStack(spacing: 12) {
            Spacer()
            
            Text("DueMate")
                .font(.system(size: 36, weight: .bold))
                .foregroundColor(.primary)
            
            Text("Smart Task Management")
                .font(.subheadline)
                .foregroundColor(.secondary)
            
            Spacer()
            
            Text("Created by")
                .font(.caption)
                .foregroundColor(.secondary)
            
            Text("Parsa Molahosseini, Kevin George buhein, Mehrad Bayat")
                .font(.caption)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 40)
                .padding(.bottom, 40)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color(.systemBackground))
    }
}

#Preview {
    LaunchScreenView()
}
