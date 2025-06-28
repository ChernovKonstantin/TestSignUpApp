import SwiftUI

enum UsersServiceRequests {
    
    struct UserPosition: APIRequest {
        
        typealias Result = PositionsResponse
        
        
        var endpoint: String { "/positions" }
        var method: HTTPMethod { .get }

    }
    
    struct UsersList: APIRequest {
        typealias Result = UsersResponse
        
        var page: Int
        
        var endpoint: String { "/users" }
        var method: HTTPMethod { .get }
        var parameters: [String: Any]? {
            [
                "page": page,
                "count": 6
            ]
        }
    }
    
    struct UserInfo: APIRequest {
        typealias Result = User
        
        var userId: Int
        
        var endpoint: String { "/users/\(userId)" }
        var method: HTTPMethod { .get }

    }
    
    struct Token: APIRequest {
        typealias Result = TokenResponse
        
        
        var endpoint: String { "/token" }
        var method: HTTPMethod { .post }

    }
    
    struct CreateUser: APIRequest {
        typealias Result = RegistrationResponse
        
        var user: NewUser
        
        var endpoint: String { "/users" }
        var method: HTTPMethod { .post }
        var bodyType: String { BodyType.multipart.rawValue }
        var multipartBody: [MultipartFormField]? {
            let fields: [MultipartFormField] = [
                .text(name: "name", value: user.name),
                .text(name: "email", value: user.email),
                .text(name: "phone", value: user.phone),
                .integer(name: "position_id", value: user.positionId),
                .file(name: "photo", fileName: "photo.jpg", mimeType: "image/jpeg", data: user.photo)
            ]
            return fields
        }
        var headers: [String : String]?
    }
    
    struct LoadImage: APIRequest {
        typealias Result = Data
        
        var stringURL: String
        
        var baseUrl: URL? { URL(string: stringURL) }
        var endpoint: String { "" }
        var method: HTTPMethod { .get }
    }
}
