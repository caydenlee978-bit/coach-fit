import SwiftUI

struct HomeView: View {
    var body: some View {
        List {
            Section("Today") {
                Label("Welcome to CoachFit", systemImage: "sparkles")
                Label("Track workouts and nutrition", systemImage: "checkmark.circle")
            }
        }
        .navigationTitle("Home")
    }
}

#Preview {
    NavigationStack {
        HomeView()
    }
}
