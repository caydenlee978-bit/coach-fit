import SwiftUI

struct ProfileView: View {
    var body: some View {
        ScrollView {
            VStack(spacing: 18) {
                VStack(spacing: 10) {
                    Circle()
                        .fill(LinearGradient(colors: [.mint, .blue], startPoint: .topLeading, endPoint: .bottomTrailing))
                        .frame(width: 88, height: 88)
                        .overlay {
                            Text("CF")
                                .font(.title3.bold())
                                .foregroundStyle(.white)
                        }
                    Text("Chris Foster")
                        .font(.title3.bold())
                        .foregroundStyle(.white)
                    Text("Pro Member")
                        .font(.caption)
                        .padding(.horizontal, 10)
                        .padding(.vertical, 5)
                        .background(Color.mint.opacity(0.2), in: Capsule())
                        .foregroundStyle(.mint)
                }

                VStack(spacing: 12) {
                    profileRow(icon: "flame.fill", title: "Current Streak", value: "9 days")
                    profileRow(icon: "dumbbell.fill", title: "Workouts Completed", value: "124")
                    profileRow(icon: "fork.knife", title: "Meals Logged", value: "312")
                    profileRow(icon: "gearshape.fill", title: "Settings", value: "Account")
                }
            }
            .padding()
        }
        .background(Color.black)
        .navigationTitle("Profile")
    }

    private func profileRow(icon: String, title: String, value: String) -> some View {
        HStack(spacing: 12) {
            Image(systemName: icon)
                .frame(width: 34, height: 34)
                .foregroundStyle(.mint)
                .background(Color.mint.opacity(0.15), in: RoundedRectangle(cornerRadius: 10))

            Text(title)
                .foregroundStyle(.white)
                .font(.subheadline)

            Spacer()

            Text(value)
                .foregroundStyle(.secondary)
                .font(.caption)
        }
        .padding()
        .background(Color.white.opacity(0.05), in: RoundedRectangle(cornerRadius: 14))
    }
}

#Preview {
    NavigationStack {
        ProfileView()
    }
}
