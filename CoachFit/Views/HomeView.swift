import SwiftUI

struct HomeView: View {
    private let quickActions: [QuickAction] = [
        .init(icon: "bolt.fill", title: "Start Workout", subtitle: "Push day · 48 min", color: .mint),
        .init(icon: "fork.knife", title: "Log Meal", subtitle: "2 meals remaining", color: .orange),
        .init(icon: "chart.line.uptrend.xyaxis", title: "Progress", subtitle: "+3.2% strength", color: .purple)
    ]

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 18) {
                heroCard

                Text("Quick Actions")
                    .font(.headline)
                    .foregroundStyle(.white)

                ForEach(quickActions) { action in
                    ActionRow(action: action)
                }

                sectionHeader("Today")

                StatCard(title: "Calories", value: "1,860", detail: "of 2,200", color: .orange)
                StatCard(title: "Hydration", value: "2.6L", detail: "goal: 3.0L", color: .blue)
                StatCard(title: "Recovery", value: "84%", detail: "Excellent", color: .green)
            }
            .padding()
        }
        .background(Color.black)
        .navigationTitle("CoachFit")
    }

    private var heroCard: some View {
        ZStack(alignment: .bottomLeading) {
            LinearGradient(colors: [.mint.opacity(0.8), .blue.opacity(0.7)], startPoint: .topLeading, endPoint: .bottomTrailing)
                .frame(height: 190)
                .clipShape(RoundedRectangle(cornerRadius: 24, style: .continuous))

            VStack(alignment: .leading, spacing: 8) {
                Text("You’re on a 9 day streak")
                    .font(.headline)
                Text("Strength + Mobility")
                    .font(.title2.bold())
                Text("Today: Lower body focus")
                    .font(.subheadline)
                    .opacity(0.9)
            }
            .foregroundStyle(.white)
            .padding(20)
        }
    }

    private func sectionHeader(_ title: String) -> some View {
        Text(title)
            .font(.headline)
            .foregroundStyle(.white)
            .padding(.top, 8)
    }
}

private struct QuickAction: Identifiable {
    let id = UUID()
    let icon: String
    let title: String
    let subtitle: String
    let color: Color
}

private struct ActionRow: View {
    let action: QuickAction

    var body: some View {
        HStack(spacing: 14) {
            Image(systemName: action.icon)
                .font(.title3)
                .frame(width: 42, height: 42)
                .background(action.color.opacity(0.18), in: RoundedRectangle(cornerRadius: 12, style: .continuous))
                .foregroundStyle(action.color)

            VStack(alignment: .leading, spacing: 2) {
                Text(action.title)
                    .font(.subheadline.bold())
                    .foregroundStyle(.white)
                Text(action.subtitle)
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }

            Spacer()

            Image(systemName: "chevron.right")
                .font(.caption.weight(.bold))
                .foregroundStyle(.secondary)
        }
        .padding()
        .background(Color.white.opacity(0.06), in: RoundedRectangle(cornerRadius: 16, style: .continuous))
    }
}

private struct StatCard: View {
    let title: String
    let value: String
    let detail: String
    let color: Color

    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            Text(title)
                .font(.caption)
                .foregroundStyle(.secondary)
            HStack {
                Text(value)
                    .font(.title3.bold())
                    .foregroundStyle(.white)
                Spacer()
                Text(detail)
                    .font(.caption.weight(.medium))
                    .foregroundStyle(color)
            }
        }
        .padding()
        .background(Color.white.opacity(0.05), in: RoundedRectangle(cornerRadius: 16, style: .continuous))
    }
}

#Preview {
    NavigationStack {
        HomeView()
    }
}
