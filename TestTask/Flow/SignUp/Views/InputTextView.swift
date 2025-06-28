import SwiftUI

struct InputTextView: View {
    @Binding var text: String
    @Binding var errorMessage: String
    @Binding var photo: UIImage?
    @FocusState private var isFocused: Bool
    
    var fieldType: FieldType = .text
    
    let placeholder: String
    let supportiveText: String?
    
    private var shouldFloat: Bool {
        isFocused || !text.isEmpty
    }
    
    
    
    private var supportiveColor: Color {
        !errorMessage.isEmpty ? Color(.error) : isFocused ? Color(.secondaryGreen) : Color(.border)
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            HStack {
                ZStack(alignment: .leading) {
                    Text(placeholder)
                        .foregroundColor(supportiveColor)
                        .background(Color.white)
                        .scaleEffect(shouldFloat ? 0.75 : 1.0, anchor: .leading)
                        .offset(y: shouldFloat ? -12 : 0)
                        .animation(.easeOut(duration: 0.2), value: shouldFloat)
                        .frame(height: 16)
                        .padding(.horizontal, 16)
                    
                    
                    TextField("", text: $text)
                        .frame(height: 24, alignment: .center)
                        .font(.body1)
                        .disabled(fieldType == .photo)
                        .padding(.horizontal, 16)
                        .offset(y: 8)
                    
                }
                if fieldType == .photo {
                    ImagePicker(image: $photo)
                        .padding(.horizontal, 24)
                }
            }
            .frame(height: 56, alignment: .center)
            .overlay(
                RoundedRectangle(cornerRadius: 6)
                    .stroke(supportiveColor, lineWidth: 1)
            )
            .padding(.horizontal, 16)
            
            if !errorMessage.isEmpty {
                Text(errorMessage)
                    .font(.body3)
                    .foregroundColor(.error)
                    .padding(.horizontal, 32)
                    .transition(.opacity)
                
            }
            
            if let text = supportiveText {
                Text(text)
                    .font(.body3)
                    .foregroundColor(Color(.black60))
                    .padding(.horizontal, 32)
                    .transition(.opacity)
            }
        }
        .focused($isFocused)
        .animation(.easeInOut(duration: 0.2), value: errorMessage)
    }
}

enum FieldType {
    case text
    case photo
}

#Preview {
    InputTextView(text: .constant("1x"), errorMessage: .constant(""), photo: .constant(nil), placeholder: "Name", supportiveText: "+3")
}
