import SwiftUI

struct CoachesView: View {
    var body: some View {
        VStack(spacing: 16) {
            Image(systemName: "person.3.sequence.fill")
                .font(.system(size: 48))
            Text("Coaches")
                .font(.title2.bold())
            Text("Browse and follow coaches here.")
                .multilineTextAlignment(.center)
                .foregroundStyle(.secondary)
        }
        .padding()
        .navigationTitle("Coaches")
    }
}

#Preview {
    NavigationStack {
        CoachesView()
    }
}
