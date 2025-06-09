import SwiftUI

struct AddPlantView: View {
    @Binding var plants: [Plant]
    @State private var species: String = ""
    @State private var nickname: String = ""
    @State private var showImagePicker: Bool = false
    @State private var image: UIImage?

    var body: some View {
        Form {
            TextField("Species", text: $species)
            TextField("Nickname", text: $nickname)
            Button("Identify from Photo") {
                showImagePicker = true
            }
            if let image = image {
                Image(uiImage: image).resizable().scaledToFit()
            }
            Button("Save") {
                let plant = Plant(species: species, nickname: nickname.isEmpty ? nil : nickname, idealLight: nil, idealSoilHumidity: nil, idealTemperature: nil, idealAirHumidity: nil)
                plants.append(plant)
            }
        }
        .sheet(isPresented: $showImagePicker) {
            ImagePicker(image: $image, onImagePicked: identifyPlant)
        }
    }

    func identifyPlant(image: UIImage) {
        // TODO: call ChatGPT API to identify plant and fetch ideal conditions
    }
}

struct AddPlantView_Previews: PreviewProvider {
    static var previews: some View {
        AddPlantView(plants: .constant([]))
    }
}
