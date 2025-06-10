import SwiftUI

struct AddDeviceView: View {
    @Binding var devices: [Device]
    @State private var name: String = ""
    @State private var identifier: String = ""

    var body: some View {
        Form {
            TextField("Device Name", text: $name)
            TextField("Identifier", text: $identifier)
            Button("Save") {
                let device = Device(name: name, identifier: identifier)
                devices.append(device)
            }
        }
        .navigationTitle("Add Device")
    }
}

struct AddDeviceView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            AddDeviceView(devices: .constant([]))
        }
    }
}
