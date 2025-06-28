import SwiftUI

struct RootView: View {
    @State private var selectedTab = 0
    @StateObject var viewModel: RootViewModel
    
    var body: some View {
        ZStack {
            VStack(spacing: 0) {
                ZStack {
                    switch selectedTab {
                    case 0:
                        viewModel.createUsersView()
                    case 1:
                        viewModel.createSignUpView()
                    default:
                        EmptyView()
                    }
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                
                HStack(alignment: .top) {
                    TabBarItem(
                        icon: "person.3.fill",
                        label: "Users",
                        isSelected: selectedTab == 0
                    ) {
                        selectedTab = 0
                    }
                    .frame(maxWidth: .infinity)
                    
                    
                    TabBarItem(
                        icon: "person.crop.circle.fill.badge.plus",
                        label: "Sign Up",
                        isSelected: selectedTab == 1
                    ) {
                        selectedTab = 1
                    }
                    .frame(maxWidth: .infinity)
                }
                .frame(height: 56)
                .background(Color(.systemGray6))
                .padding(.bottom, 16)
            }
            .edgesIgnoringSafeArea(.bottom)
            
            if viewModel.instnetStatus != .satisfied {
            Color.background
                .ignoresSafeArea()
                noInternet
            }
        }
        .onAppear {
            viewModel.checkInternetStatus()
        }
    }
    
    @ViewBuilder private var noInternet: some View {
        VStack(spacing: 24) {
            Image(.noInternet)
                .resizable()
                .frame(width: 200, height: 200)
            Text("There is no internet connection")
                .font(.heading1)
                .foregroundStyle(Color(.black87))
            Button(
                action: {
                    viewModel.checkInternetStatus()
                },
                label: {
                    Text("Try again")
                        .font(.body2)
                        .foregroundStyle(Color(.black87))
                        .frame(width: 140, height: 48)
                        .background(Color(.primaryYellow))
                        .clipShape(RoundedRectangle(cornerRadius: 24))
                }
            )
        }
    }
}

#Preview {
    RootView(viewModel: RootView.RootViewModel(diContainer: .preview))
}
