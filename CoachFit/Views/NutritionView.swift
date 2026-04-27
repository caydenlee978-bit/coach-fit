import SwiftUI

struct NutritionView: View {
    private let meals: [Meal] = [
        .init(name: "Protein Oats", macros: "P 32 · C 48 · F 12", calories: "420 kcal"),
        .init(name: "Salmon Rice Bowl", macros: "P 44 · C 62 · F 18", calories: "610 kcal"),
        .init(name: "Greek Yogurt + Berries", macros: "P 24 · C 22 · F 4", calories: "230 kcal")
    ]

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                macroRingCard

                Text("Meals")
                    .font(.headline)
                    .foregroundStyle(.white)

                ForEach(meals) { meal in
                    HStack {
                        VStack(alignment: .leading, spacing: 4) {
                            Text(meal.name)
                                .font(.subheadline.bold())
                                .foregroundStyle(.white)
                            Text(meal.macros)
                                .font(.caption)
                                .foregroundStyle(.secondary)
                        }
                        Spacer()
                        Text(meal.calories)
                            .font(.caption.weight(.semibold))
                            .foregroundStyle(.mint)
                    }
                    .padding()
                    .background(Color.white.opacity(0.05), in: RoundedRectangle(cornerRadius: 16))
                }
            }
            .padding()
        }
        .background(Color.black)
        .navigationTitle("Nutrition")
    }

    private var macroRingCard: some View {
        HStack(spacing: 18) {
            ZStack {
                Circle().stroke(Color.white.opacity(0.08), lineWidth: 12)
                Circle()
                    .trim(from: 0, to: 0.78)
                    .stroke(.mint, style: StrokeStyle(lineWidth: 12, lineCap: .round))
                    .rotationEffect(.degrees(-90))
                Text("78%")
                    .font(.headline.bold())
                    .foregroundStyle(.white)
            }
            .frame(width: 94, height: 94)

            VStack(alignment: .leading, spacing: 6) {
                Text("Daily Goal")
                    .font(.caption)
                    .foregroundStyle(.secondary)
                Text("1,716 / 2,200 kcal")
                    .font(.headline)
                    .foregroundStyle(.white)
                Text("Protein on target")
                    .font(.caption)
                    .foregroundStyle(.mint)
            }

            Spacer()
        }
        .padding()
        .background(Color.white.opacity(0.05), in: RoundedRectangle(cornerRadius: 18))
    }
}

private struct Meal: Identifiable {
    let id = UUID()
    let name: String
    let macros: String
    let calories: String
}

#Preview {
    NavigationStack {
        NutritionView()
    }
}
