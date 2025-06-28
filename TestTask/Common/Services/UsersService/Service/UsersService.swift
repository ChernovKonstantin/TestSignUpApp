import SwiftUI

protocol UsersService {
    
    func getUsersListFor(page: Int) async throws -> UsersResponse
    func getUserWith(id: Int) async throws -> User
    func getPositions() async throws -> [Position]
    func createUser(user: NewUser) async throws -> Bool
    func loadUserImage(for user: User) async throws -> Image?
}
