import SwiftUI

struct CustomTextFieldStyle: TextFieldStyle {
    func _body(configuration: TextField<Self._Label>) -> some View {
        return configuration
        //            .textFieldStyle(.plain)
        //            .padding(.horizontal, 8)
        //            .frame(height: 45)
        //            .cornerRadius(10)
        //            .foregroundColor(.black)
        //            .accentColor(.purple)
        //            .autocorrectionDisabled()
        //            .textInputAutocapitalization(.never)
        
            .padding(.horizontal, 12)
            .frame(height: 45)
            .background(
                RoundedRectangle(cornerRadius: 10)
                    .stroke(Color.gray.opacity(0.5), lineWidth: 2)
            )
            .foregroundColor(.black)
            .accentColor(.purple)
            .autocorrectionDisabled()
            .textInputAutocapitalization(.never)
    }
}
