import SwiftUI


final class UsersServiceImpl: UsersService {
    
    private let apiService: APIService
    
    init(apiService: APIService) {
        self.apiService = apiService
    }
    
    private func getToken() async throws -> String {
        try await apiService.fetch(
            UsersServiceRequests.Token()
        ).token
    }
    
    func loadUserImage(for user: User) async throws -> Image? {
        let data = try await apiService.download(
            UsersServiceRequests.LoadImage(stringURL: user.photo)
        )
        guard let uiImage = UIImage(data: data) else { return nil }
        return Image(uiImage: uiImage)
    }
    
    func getUsersListFor(page: Int) async throws -> UsersResponse {
        try await apiService.fetch(
            UsersServiceRequests.UsersList(page: page)
        )
    }
    
    func getUserWith(id: Int) async throws -> User {
        try await apiService.fetch(
            UsersServiceRequests.UserInfo(userId: id)
        )
    }
    
    func getPositions() async throws -> [Position] {
        try await apiService.fetch(
            UsersServiceRequests.UserPosition()
        ).positions
    }
    
    func createUser(user: NewUser) async throws -> Bool {
        let token = try await getToken()
        let response = try await apiService.fetch(
            UsersServiceRequests.CreateUser(user: user, headers: ["Token" : token])
        )
        return response.success
    }
}
