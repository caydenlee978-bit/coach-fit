import SwiftUI

struct WorkoutView: View {
    private let plans: [WorkoutPlan] = [
        .init(name: "Push · Chest + Triceps", duration: "48 min", difficulty: "Intermediate"),
        .init(name: "Pull · Back + Biceps", duration: "52 min", difficulty: "Intermediate"),
        .init(name: "Legs + Core", duration: "55 min", difficulty: "Advanced")
    ]

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                RoundedRectangle(cornerRadius: 24)
                    .fill(.ultraThinMaterial)
                    .frame(height: 150)
                    .overlay(alignment: .leading) {
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Today’s Plan")
                                .font(.caption)
                                .foregroundStyle(.secondary)
                            Text("Push Strength")
                                .font(.title2.bold())
                                .foregroundStyle(.white)
                            Text("5 exercises · 4 sets each")
                                .font(.subheadline)
                                .foregroundStyle(.secondary)
                            Button("Start Session") {}
                                .buttonStyle(.borderedProminent)
                                .tint(.mint)
                        }
                        .padding()
                    }

                Text("Program Split")
                    .font(.headline)
                    .foregroundStyle(.white)

                ForEach(plans) { plan in
                    VStack(alignment: .leading, spacing: 6) {
                        Text(plan.name)
                            .foregroundStyle(.white)
                            .font(.subheadline.bold())
                        HStack {
                            Label(plan.duration, systemImage: "clock")
                            Label(plan.difficulty, systemImage: "flame")
                        }
                        .font(.caption)
                        .foregroundStyle(.secondary)
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding()
                    .background(Color.white.opacity(0.05), in: RoundedRectangle(cornerRadius: 16))
                }
            }
            .padding()
        }
        .background(Color.black)
        .navigationTitle("Workout")
    }
}

private struct WorkoutPlan: Identifiable {
    let id = UUID()
    let name: String
    let duration: String
    let difficulty: String
}

#Preview {
    NavigationStack {
        WorkoutView()
    }
}
