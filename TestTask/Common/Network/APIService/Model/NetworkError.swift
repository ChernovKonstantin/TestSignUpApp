enum NetworkError: Error {
    case invalidURL
    case invalidData
    case invalidResponse
    case invalidStatusCode(Int)
    case expiredToken
    case userExists
    case validationError([String: [String]])
}
