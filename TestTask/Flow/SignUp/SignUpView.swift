import SwiftUI

struct SignUpView: View {
    
    @ObservedObject var viewModel: SignUpViewModel
    
    var body: some View {
        ZStack {
            ScrollView {
                VStack(spacing: 32) {
                    headerView
                    inputsContsainer
                    Spacer()
                }
            }
            if let success = viewModel.userCreationSuccess {
                Color(.background)
                    .ignoresSafeArea()
                successView(success)
            }
        }
    }
    
    @ViewBuilder private func successView(_ success: Bool) -> some View {
        VStack(spacing: 24) {
            
            HStack{
                Spacer()
                Image(systemName: "xmark")
                    .resizable()
                    .frame(width: 14, height: 14)
                    .foregroundStyle(Color(.black48))
                    .onTapGesture {
                        viewModel.resetInputs()
                    }
                    .padding(29)
            }
            Spacer()
            Image(success ? .usersSuccess : .usersFail)
                .resizable()
                .frame(width: 200, height: 200)
            Text(success ? "User successfully registered" : viewModel.userCreationError ?? "Error occured")
                .font(.heading1)
                .foregroundStyle(Color(.black87))
            Button(
                action: {
                    viewModel.resetInputs()
                },
                label: {
                    Text(success ? "Got it" : "Try again")
                        .font(.body2)
                        .foregroundStyle(Color(.black87))
                        .frame(width: 140, height: 48)
                        .background(Color(.primaryYellow))
                        .clipShape(RoundedRectangle(cornerRadius: 24))
                }
            )
            
            Spacer()
        }
        .padding(.bottom, 29)
    }
    
    @ViewBuilder private var headerView: some View {
        HStack {
            Text("Working with POST request")
                .frame(maxWidth: .infinity, minHeight: 56)
                .font(.heading1)
                .background(Color(.primaryYellow))
                .padding(.top, 1)
        }
        
    }
    
    @ViewBuilder private var inputsContsainer: some View {
        VStack(spacing: 24) {
            credentialsInputs
            positionRadioSelector
            photoSelector
            signUpButton
        }
    }
    
    @ViewBuilder private var credentialsInputs: some View {
        VStack(spacing: 24) {
            InputTextView(text: $viewModel.name, errorMessage: $viewModel.nameError, photo: .constant(nil), placeholder: "Your name", supportiveText: nil)
            
            InputTextView(text: $viewModel.email, errorMessage: $viewModel.emailError, photo: .constant(nil), placeholder: "Email", supportiveText: nil)
            
            InputTextView(text: $viewModel.phone, errorMessage: $viewModel.phoneError, photo: .constant(nil), placeholder: "Phone", supportiveText: "+38 (XXX) XXX - XX - XX")
        }
    }
    
    @ViewBuilder private var positionRadioSelector: some View {
        if let positions = viewModel.positions {
            VStack(alignment: .leading) {
                Text("Select your position")
                    .font(.body2)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.bottom, 12)
                ForEach(positions, id: \.id) { position in
                    HStack {
                        Image(viewModel.positionID == position.id ? .radioSelected : .radioDeselected)
                            .resizable()
                            .frame(width: 14, height: 14)
                            .padding(17)
                        Text(position.name)
                            .font(.body1)
                        Spacer()
                    }
                    .frame(height: 48)
                    .onTapGesture {
                        viewModel.positionID = position.id
                    }
                }
            }
            .padding(.horizontal, 16)
        } else {
            ProgressView()
        }
    }
    
    @ViewBuilder private var photoSelector: some View {
        InputTextView(text: $viewModel.photoText, errorMessage: $viewModel.photoError, photo: $viewModel.photo, fieldType: .photo, placeholder: "Upload your photo", supportiveText: nil)
    }
    
    @ViewBuilder private var signUpButton: some View {
        Button(
            action: {
                viewModel.signUpTap()
            },
            label: {
                Text("Sign up")
                    .font(.body2)
                    .foregroundStyle((viewModel.canSignUp && !viewModel.isLoading) ? Color(.black87) : Color(.black48) )
                    .frame(width: 140, height: 48)
                    .background((viewModel.canSignUp && !viewModel.isLoading) ? Color(.primaryYellow) : Color(.disabled))
                    .clipShape(RoundedRectangle(cornerRadius: 24))
            }
        )
        .disabled(!viewModel.canSignUp || viewModel.isLoading)
    }
}

#Preview {
    SignUpView(viewModel: SignUpView.SignUpViewModel(diContainer: .preview))
}
