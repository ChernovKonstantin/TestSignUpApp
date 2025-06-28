import Foundation

struct RegistrationResponse: Codable {
    let success: Bool
    let userId: Int
    let message: String
}

struct UsersResponse: Codable {
    let success: Bool
    let page: Int
    let totalPages: Int
    let totalUsers: Int
    let count: Int
    let links: Links
    let users: [User]
}

struct Links: Codable {
    let nextURL: URL?
    let prevURL: URL?
}

struct User: Codable, Identifiable {
    let id: Int
    let name: String
    let email: String
    let phone: String
    let position: String
    let positionId: Int
    let registrationTimestamp: Int?
    let photo: String
}

struct NewUser: Codable {
    let name: String
    let email: String
    let phone: String
    let positionId: Int
    let photo: Data
    
    enum CodingKeys: String, CodingKey {
            case name, email, phone, photo
            case positionId = "position_id"
        }
}

struct PositionsResponse: Codable {
    let positions: [Position]
}

struct Position: Codable, Identifiable {
    let id: Int
    let name: String
}

struct ErrorResponse: Codable {
    let message: String
    let fails: [String: [String]]
}

struct TokenResponse: Codable {
    let token: String
}

enum MultipartFormField {
    case text(name: String, value: String)
    case integer(name: String, value: Int)
    case file(name: String, fileName: String, mimeType: String, data: Data)
}
