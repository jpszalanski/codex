import SwiftUI

struct LocationManagementView: View {
    @State private var locations: [Location] = []
    @State private var newLocationName: String = ""

    var body: some View {
        VStack {
            List {
                ForEach(locations) { location in
                    Text(location.name)
                }
            }
            HStack {
                TextField("Add Location", text: $newLocationName)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                Button("Add") {
                    let location = Location(name: newLocationName, areas: [])
                    locations.append(location)
                    newLocationName = ""
                }
            }.padding()
        }
        .navigationTitle("Locations")
    }
}

struct LocationManagementView_Previews: PreviewProvider {
    static var previews: some View {
        LocationManagementView()
    }
}
