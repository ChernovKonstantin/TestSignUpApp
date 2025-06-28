import Foundation

protocol APIRequest {
    associatedtype Result: Decodable

    var baseUrl: URL? { get }
    var endpoint: String { get }
    var method: HTTPMethod { get }
    var bodyType: String { get }
    var body: [String: Any]? { get }
    var multipartBody: [MultipartFormField]? { get }
    var headers: [String: String]? { get }
    var parameters: [String: Any]? { get }
}

protocol APIService: AnyObject {

    func fetch<T: APIRequest>(_ convertible: T) async throws -> T.Result
    
    func download<T: APIRequest>(_ convertible: T) async throws -> Data
}

extension APIRequest {
    
    var baseUrl: URL? { nil }
    var body: [String: Any]? { nil }
    var headers: [String: String]? { nil }
    var parameters: [String: Any]? { nil }
    var bodyType: String { BodyType.json.rawValue }
    var multipartBody: [MultipartFormField]? { nil }

    var encoder: JSONEncoder {
        let encoder = JSONEncoder()
        encoder.keyEncodingStrategy = .convertToSnakeCase
        return encoder
    }
}
