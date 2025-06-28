import SwiftUI

extension UsersView {
    final class UsersViewModel: ObservableObject {
        @Published var users: [User] = []
        @Published var userPhotos: [Int: Image] = [:]
        @Published var initialLoad: Bool = true
        @Published var loadingMoreUsers: Bool = false
        
        private var totalPages: Int = 0
        private var currentPage: Int = 1
        private let diContainer: DIContainer
        
        init(diContainer: DIContainer) {
            self.diContainer = diContainer
            
            loadUsers()
        }
        
        func loadMoreUsersIfNeeded(currentUser: User) {
            if let lastUser = users.last, currentUser.id == lastUser.id, currentPage < totalPages {
                currentPage += 1
                loadingMoreUsers = true
                loadUsers()
            }
        }
        
        private func loadUsers() {
            Task {
                do {
                    let usersResponse = try await diContainer.services.usersService.getUsersListFor(page: currentPage)
                    loadPhoto(for: usersResponse.users)
                    await MainActor.run { [weak self] in
                        self?.users += usersResponse.users.sorted { $0.registrationTimestamp ?? 0 > $1.registrationTimestamp ?? 1 }
                        self?.totalPages = usersResponse.totalPages
                        self?.initialLoad = false
                        self?.loadingMoreUsers = false
                    }
                } catch {
                    print(error.localizedDescription)
                    await MainActor.run { [weak self] in
                        self?.initialLoad = false
                        self?.loadingMoreUsers = false
                    }
                }
            }
        }
        
        private func loadPhoto(for users: [User]) {
            users.forEach { user in
                Task {
                    do {
                        let image = try await diContainer.services.usersService.loadUserImage(for: user)
                        await MainActor.run { [weak self] in
                            self?.userPhotos[user.id] = image
                        }
                    }
                    catch {
                        print(error.localizedDescription)
                        await MainActor.run { [weak self] in
                            self?.userPhotos[user.id] = Image(systemName: "photo.circle")
                        }
                    }
                }
            }
        }
    }
}
