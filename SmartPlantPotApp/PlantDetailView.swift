import SwiftUI

struct PlantDetailView: View {
    var plant: Plant
    @State private var currentLight: Double?
    @State private var currentSoilHumidity: Double?
    @State private var currentTemperature: Double?
    @State private var currentAirHumidity: Double?

    var body: some View {
        VStack(alignment: .leading) {
            Text(plant.displayName).font(.title)
            if let ideal = plant.idealLight {
                HStack {
                    Text("Light: \(currentLight ?? 0, specifier: "%.1f") / \(ideal, specifier: "%.1f")")
                    alertIcon(current: currentLight, ideal: ideal)
                }
            }
            if let ideal = plant.idealSoilHumidity {
                HStack {
                    Text("Soil Humidity: \(currentSoilHumidity ?? 0, specifier: "%.1f") / \(ideal, specifier: "%.1f")")
                    alertIcon(current: currentSoilHumidity, ideal: ideal)
                }
            }
            if let ideal = plant.idealTemperature {
                HStack {
                    Text("Temperature: \(currentTemperature ?? 0, specifier: "%.1f") / \(ideal, specifier: "%.1f")")
                    alertIcon(current: currentTemperature, ideal: ideal)
                }
            }
            if let ideal = plant.idealAirHumidity {
                HStack {
                    Text("Air Humidity: \(currentAirHumidity ?? 0, specifier: "%.1f") / \(ideal, specifier: "%.1f")")
                    alertIcon(current: currentAirHumidity, ideal: ideal)
                }
            }
            Spacer()
        }
        .padding()
        .onAppear {
            // TODO: load sensor values
        }
    }

    func alertIcon(current: Double?, ideal: Double) -> some View {
        if let current = current {
            if current < ideal * 0.9 {
                return Image(systemName: "arrow.down.circle").foregroundColor(.blue)
            } else if current > ideal * 1.1 {
                return Image(systemName: "arrow.up.circle").foregroundColor(.red)
            }
        }
        return Image(systemName: "checkmark.circle").foregroundColor(.green)
    }
}

struct PlantDetailView_Previews: PreviewProvider {
    static var previews: some View {
        PlantDetailView(plant: Plant(species: "Ficus", nickname: "My Plant", idealLight: 5, idealSoilHumidity: 40, idealTemperature: 22, idealAirHumidity: 60))
    }
}
