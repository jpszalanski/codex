import SwiftUI

struct DeviceManagementView: View {
    @Binding var devices: [Device]

    var body: some View {
        List {
            ForEach(devices) { device in
                Text(device.name)
            }
        }
        .navigationTitle("Devices")
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                NavigationLink(destination: AddDeviceView(devices: $devices)) {
                    Image(systemName: "plus")
                }
            }
        }
    }
}

struct DeviceManagementView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            DeviceManagementView(devices: .constant([]))
        }
    }
}
