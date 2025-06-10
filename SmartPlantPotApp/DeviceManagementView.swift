import SwiftUI

struct DeviceManagementView: View {
    @EnvironmentObject var session: UserSession

    var body: some View {
        List {
            ForEach(session.user.devices) { device in
                Text(device.name)
            }
        }
        .navigationTitle("Devices")
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                NavigationLink(destination: AddDeviceView()) {
                    Image(systemName: "plus")
                }
            }
        }
    }
}

struct DeviceManagementView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            DeviceManagementView()
                .environmentObject(UserSession(user: User(email: "", password: "", locations: [], devices: [])))
        }
    }
}
