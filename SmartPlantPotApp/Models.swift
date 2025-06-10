import Foundation

struct User: Identifiable {
    let id = UUID()
    var email: String
    var password: String
    var locations: [Location]
    /// Devices linked to this user account
    var devices: [Device]
}

/// Represents a physical sensor device that can upload data for the user.
struct Device: Identifiable {
    let id = UUID()
    /// Friendly name chosen by the user
    var name: String
    /// Unique identifier from the hardware (e.g. serial number)
    var identifier: String
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
