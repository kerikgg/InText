import SwiftUI

struct CustomTextField: View {
    private var title: String
    private var text: Binding<String>
    private var prompt: String?
    private var isSecure: Bool

    init(title: String, text: Binding<String>, prompt: String? = nil, isSecure: Bool = false) {
        self.title = title
        self.text = text
        self.prompt = prompt
        self.isSecure = isSecure
    }

    var body: some View {
        VStack(alignment: .leading) {
            if isSecure {
                SecureField(title, text: text)
                    .textFieldStyle(CustomTextFieldStyle())
                    .background(prompt == nil ? Color.white.opacity(0.1) : Color.red.opacity(0.15))
                    .background(
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(prompt == nil ? Color.gray.opacity(0.5) : Color.red, lineWidth: 2)
                    )
                    .cornerRadius(10)
            } else {
                TextField(title, text: text)
                    .textFieldStyle(CustomTextFieldStyle())
                    .background(prompt == nil ? Color.white.opacity(0.1) : Color.red.opacity(0.15))
                    .background(
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(prompt == nil ? Color.gray.opacity(0.5) : Color.red, lineWidth: 2)
                    )
                    .cornerRadius(10)
            }
            
            if let prompt = prompt {
                Text(prompt)
                    .foregroundColor(.red)
                    .font(.caption)
                    .padding(.horizontal)
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}
