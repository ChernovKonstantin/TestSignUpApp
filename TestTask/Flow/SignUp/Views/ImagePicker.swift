import SwiftUI
import PhotosUI

struct ImagePicker: View {
    @Binding var image: UIImage?
    @State private var showCamera = false
    @State private var showGallery = false
    @State private var showPickerDialog = false

    var body: some View {
        VStack(spacing: 20) {
            Button(
                action: {
                    showPickerDialog = true
                }, label: {
                    Text("Upload")
                        .foregroundStyle(Color.secondaryGreen)
                        .font(.body1)
                }
            )
        }
        .confirmationDialog("Choose how you want to add a photo", isPresented: $showPickerDialog, titleVisibility: .visible) {
            if UIImagePickerController.isSourceTypeAvailable(.camera) {
                Button("Camera") {
                    showCamera = true
                }
            }
            Button("Gallery") {
                showGallery = true
            }
            Button("Cancel", role: .cancel) { }
        }
        .sheet(isPresented: $showCamera) {
            CameraImagePicker(image: $image)
        }
        .sheet(isPresented: $showGallery) {
            PhotoPicker(image: $image)
        }
    }
}
