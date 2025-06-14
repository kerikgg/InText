import SwiftUI
import PhotosUI

struct ProfileAvatarView: View {
    @ObservedObject var viewModel: ProfileViewModel

    @State private var selectedItem: PhotosPickerItem?
    @State private var isUploading = false

    var body: some View {
        VStack {
            PhotosPicker(
                selection: $selectedItem,
                matching: .images,
                photoLibrary: .shared()
            ) {
                ZStack {
                    if let url = viewModel.user?.photoURL {
                        AsyncImage(url: url) { image in
                            image.resizable()
                        } placeholder: {
                            ProgressView()
                        }
                    } else {
                        Image(systemName: "person.circle.fill")
                            .resizable()
                            .foregroundColor(.purple.opacity(0.8))
                    }

                    if isUploading {
                        ProgressView()
                            .scaleEffect(1.5)
                    }
                }
                .frame(width: 100, height: 100)
                .clipShape(Circle())
            }
            .buttonStyle(.plain)
        }
        .onChange(of: selectedItem) { newItem in
            Task {
                if let data = try? await newItem?.loadTransferable(type: Data.self),
                   let image = UIImage(data: data) {
                    isUploading = true
                    ImageUploadService.shared.uploadImageToImgbb(image) { result in
                        DispatchQueue.main.async {
                            isUploading = false
                            switch result {
                            case .success(let url):
                                viewModel.updatePhotoURL(url: url)
                            case .failure(let error):
                                print("Ошибка загрузки аватара: \(error.localizedDescription)")
                            }
                        }
                    }
                }
            }
        }
    }
}

