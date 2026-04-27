import SwiftUI

struct WorkoutView: View {
    var body: some View {
        VStack(spacing: 16) {
            Image(systemName: "figure.run")
                .font(.system(size: 48))
            Text("Workout")
                .font(.title2.bold())
            Text("Your workout plans and history appear here.")
                .multilineTextAlignment(.center)
                .foregroundStyle(.secondary)
        }
        .padding()
        .navigationTitle("Workout")
    }
}

#Preview {
    NavigationStack {
        WorkoutView()
    }
}
