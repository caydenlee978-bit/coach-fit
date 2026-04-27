import SwiftUI

struct CoachesView: View {
    private let coaches: [Coach] = [
        .init(name: "Ava Martinez", specialty: "Strength & Hypertrophy", followers: "42K"),
        .init(name: "Noah Kim", specialty: "Mobility & Recovery", followers: "27K"),
        .init(name: "Sofia Patel", specialty: "Sports Nutrition", followers: "36K")
    ]

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 14) {
                Text("Featured Coaches")
                    .font(.headline)
                    .foregroundStyle(.white)

                ForEach(coaches) { coach in
                    HStack(spacing: 12) {
                        Circle()
                            .fill(LinearGradient(colors: [.purple, .mint], startPoint: .topLeading, endPoint: .bottomTrailing))
                            .frame(width: 52, height: 52)
                            .overlay {
                                Text(String(coach.name.prefix(1)))
                                    .font(.headline.bold())
                                    .foregroundStyle(.white)
                            }

                        VStack(alignment: .leading, spacing: 4) {
                            Text(coach.name)
                                .font(.subheadline.bold())
                                .foregroundStyle(.white)
                            Text(coach.specialty)
                                .font(.caption)
                                .foregroundStyle(.secondary)
                        }

                        Spacer()

                        VStack(alignment: .trailing, spacing: 6) {
                            Text(coach.followers)
                                .font(.caption.bold())
                                .foregroundStyle(.mint)
                            Button("Follow") {}
                                .buttonStyle(.bordered)
                                .tint(.mint)
                                .controlSize(.small)
                        }
                    }
                    .padding()
                    .background(Color.white.opacity(0.05), in: RoundedRectangle(cornerRadius: 16))
                }
            }
            .padding()
        }
        .background(Color.black)
        .navigationTitle("Coaches")
    }
}

private struct Coach: Identifiable {
    let id = UUID()
    let name: String
    let specialty: String
    let followers: String
}

#Preview {
    NavigationStack {
        CoachesView()
    }
}
