import SwiftUI
import Combine

struct UsersView: View {
    
    @ObservedObject var viewModel: UsersViewModel
    
    var body: some View {
        VStack {
            
            headerView
            
            Spacer()
            
            if viewModel.initialLoad {
                ProgressView()
                    .padding()
            } else if viewModel.users.isEmpty {
                emptyUsers
            } else {
                usersContainer
            }
            
            Spacer()
        }
    }
    
    @ViewBuilder private var emptyUsers: some View {
        VStack(spacing: 24) {
            Image(.noUsers)
                .resizable()
                .scaledToFit()
                .frame(width: 200, height: 200)
            Text("There are no users yet")
                .font(.heading1)
        }
    }
    
    @ViewBuilder private var headerView: some View {
        HStack {
            Text("Working with GET request")
                .frame(maxWidth: .infinity, minHeight: 56)
                .font(.heading1)
                .background(Color(.primaryYellow))
                .padding(.top, 1)
        }
       
    }
    
    @ViewBuilder private var usersContainer: some View {
        ScrollView {
            LazyVStack {
                ForEach(viewModel.users, id: \.id) { user in
                    UserLineView(user: user, photo: viewModel.userPhotos[user.id])
                        .onAppear {
                            viewModel.loadMoreUsersIfNeeded(currentUser: user)
                        }
                    Divider()
                        .padding(.leading, 82)
                        .padding(.trailing, 16)
                }
                if viewModel.loadingMoreUsers {
                    ProgressView()
                        .frame(width: 30, height: 30)
                        .padding()
                }
            }
        }
    }
}

#Preview {
    UsersView(viewModel: UsersView.UsersViewModel(diContainer: .preview))
}
