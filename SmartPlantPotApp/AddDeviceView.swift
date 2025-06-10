import SwiftUI

struct AddDeviceView: View {
    @EnvironmentObject var session: UserSession
    @State private var name: String = ""
    @State private var identifier: String = ""
    @State private var ssid: String = ""
    @State private var wifiPassword: String = ""
    @State private var provisionStatus: String?

    private func provisionDevice() {
        guard let url = URL(string: "http://192.168.4.1/wifi") else { return }
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        let body = "ssid=\(ssid)&pass=\(wifiPassword)"
        request.httpBody = body.data(using: .utf8)
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        provisionStatus = "Sending..."
        URLSession.shared.dataTask(with: request) { _, response, error in
            DispatchQueue.main.async {
                if let error = error {
                    provisionStatus = "Error: \(error.localizedDescription)"
                } else if let http = response as? HTTPURLResponse, http.statusCode == 200 {
                    provisionStatus = "Provisioned!"
                } else {
                    provisionStatus = "Failed"
                }
            }
        }.resume()
    }

    var body: some View {
        Form {
            Section(header: Text("Device")) {
                TextField("Device Name", text: $name)
                TextField("Identifier", text: $identifier)
                Button("Save") {
                    let device = Device(name: name, identifier: identifier)
                    session.user.devices.append(device)
                }
            }

            Section(header: Text("Wi-Fi")) {
                TextField("SSID", text: $ssid)
                SecureField("Password", text: $wifiPassword)
                if let status = provisionStatus {
                    Text(status).font(.footnote)
                }
                Button("Send Credentials") {
                    provisionDevice()
                }
            }
        }
        .navigationTitle("Add Device")
    }
}

struct AddDeviceView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            AddDeviceView()
                .environmentObject(UserSession(user: User(email: "", password: "", locations: [], devices: [])))
        }
    }
}
