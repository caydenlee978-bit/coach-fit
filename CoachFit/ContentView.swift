import SwiftUI

struct ContentView: View {
    var body: some View {
        TabView {
            NavigationStack {
                HomeView()
            }
            .tabItem {
                Label("Home", systemImage: "house.fill")
            }

            NavigationStack {
                WorkoutView()
            }
            .tabItem {
                Label("Workout", systemImage: "figure.strengthtraining.traditional")
            }

            NavigationStack {
                NutritionView()
            }
            .tabItem {
                Label("Nutrition", systemImage: "leaf.fill")
            }

            NavigationStack {
                CoachesView()
            }
            .tabItem {
                Label("Coaches", systemImage: "person.3.fill")
            }

            NavigationStack {
                ProfileView()
            }
            .tabItem {
                Label("Profile", systemImage: "person.crop.circle.fill")
            }
        }
        .tint(.mint)
        .background(Color.black.ignoresSafeArea())
    }
}

#Preview {
    ContentView()
}
