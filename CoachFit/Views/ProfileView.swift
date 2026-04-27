import SwiftUI

struct ProfileView: View {
    var body: some View {
        Form {
            Section("Account") {
                Label("Profile", systemImage: "person.crop.circle")
                Label("Settings", systemImage: "gearshape")
            }
        }
        .navigationTitle("Profile")
    }
}

#Preview {
    NavigationStack {
        ProfileView()
    }
}
