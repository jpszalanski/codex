import Foundation

struct User: Identifiable {
    let id = UUID()
    var email: String
    var password: String
    var locations: [Location]
}

struct Location: Identifiable {
    let id = UUID()
    var name: String
    var areas: [Area]
}

struct Area: Identifiable {
    let id = UUID()
    var name: String
    var plants: [Plant]
}

struct Plant: Identifiable {
    let id = UUID()
    var species: String
    var nickname: String?
    var idealLight: Double?
    var idealSoilHumidity: Double?
    var idealTemperature: Double?
    var idealAirHumidity: Double?
}

extension Plant {
    var displayName: String { nickname ?? species }
}
