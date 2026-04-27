import SwiftUI

struct NutritionView: View {
    var body: some View {
        VStack(spacing: 16) {
            Image(systemName: "fork.knife")
                .font(.system(size: 48))
            Text("Nutrition")
                .font(.title2.bold())
            Text("Meal plans and nutrition insights appear here.")
                .multilineTextAlignment(.center)
                .foregroundStyle(.secondary)
        }
        .padding()
        .navigationTitle("Nutrition")
    }
}

#Preview {
    NavigationStack {
        NutritionView()
    }
}
