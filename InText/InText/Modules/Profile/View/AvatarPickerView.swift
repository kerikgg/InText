import SwiftUI
import PhotosUI

struct AvatarPickerView: View {
    @ObservedObject var viewModel: ProfileViewModel

    @State private var selectedItem: PhotosPickerItem?
    @State private var selectedImageData: Data?
    @State private var isUploading = false
    @State private var uploadError: String?

    var body: some View {
        VStack(spacing: 20) {
            Text("Выберите аватар")
                .font(.title2)
                .fontWeight(.semibold)

            avatarPreview

            PhotosPicker(selection: $selectedItem, matching: .images) {
                Text("Выбрать из галереи")
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.purple.opacity(0.2))
                    .cornerRadius(10)
            }

            if selectedImageData != nil {
                Button("Сохранить") {
                    uploadAvatar()
                }
                .disabled(isUploading)
                .frame(maxWidth: .infinity)
                .padding()
                .background(isUploading ? Color.gray : Color.purple)
                .foregroundColor(.white)
                .cornerRadius(10)
            }

            if let uploadError = uploadError {
                Text(uploadError)
                    .foregroundColor(.red)
                    .font(.caption)
            }

            Spacer()
        }
        .padding()
        .onChange(of: selectedItem) { newItem in
            Task {
                if let data = try? await newItem?.loadTransferable(type: Data.self) {
                    selectedImageData = data
                }
            }
        }
    }

    private var avatarPreview: some View {
        Group {
            if let data = selectedImageData, let uiImage = UIImage(data: data) {
                Image(uiImage: uiImage)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 150, height: 150)
                    .clipShape(Circle())
            } else {
                Image(systemName: "person.crop.circle.badge.plus")
                    .resizable()
                    .frame(width: 150, height: 150)
                    .foregroundColor(.gray)
            }
        }
    }

    private func uploadAvatar() {
        guard let data = selectedImageData,
              let image = UIImage(data: data) else {
            uploadError = "Ошибка загрузки изображения."
            return
        }

        isUploading = true
        uploadError = nil

        ImageUploadService.shared.uploadImageToImgbb(image) { result in
            DispatchQueue.main.async {
                isUploading = false
                switch result {
                case .success(let url):
                    viewModel.updatePhotoURL(url: url)
                case .failure(let error):
                    uploadError = "Ошибка загрузки: \(error.localizedDescription)"
                }
            }
        }
    }
}

