import SwiftUI

struct DashboardView: View {
    @State private var plants: [Plant] = []

    var body: some View {
        NavigationView {
            List {
                ForEach(plants) { plant in
                    NavigationLink(destination: PlantDetailView(plant: plant)) {
                        Text(plant.displayName)
                    }
                }
            }
            .navigationTitle("My Plants")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    NavigationLink(destination: AddPlantView(plants: $plants)) {
                        Image(systemName: "plus")
                    }
                }
            }
        }
    }
}

struct DashboardView_Previews: PreviewProvider {
    static var previews: some View {
        DashboardView()
    }
}
