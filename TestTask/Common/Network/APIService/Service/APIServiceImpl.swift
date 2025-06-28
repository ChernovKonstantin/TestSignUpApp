import Foundation

final class APIServiceImpl {
    
    
    private let baseURL: URL? = URL(string: "https://frontend-test-assignment-api.abz.agency/api/v1")
    private let decoder: JSONDecoder = {
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        return decoder
    }()
}

extension APIServiceImpl: APIService {
    
    func fetch<T: APIRequest>(_ convertible: T) async throws -> T.Result {
        let request = try makeURLRequest(from: convertible)
        
        let (data, response) = try await URLSession.shared.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse else {
            throw NetworkError.invalidResponse
        }
        
        switch httpResponse.statusCode {
        case 200..<300:
            do {
                return try decoder.decode(T.Result.self, from: data)
            } catch {
                throw NetworkError.invalidData
            }
        case 422, 400:
            let failResponse = try decoder.decode(ErrorResponse.self, from: data)
            throw NetworkError.validationError(failResponse.fails)
        case 409:
            throw NetworkError.userExists
        case 401:
            throw NetworkError.expiredToken
        default:
            throw NetworkError.invalidStatusCode(httpResponse.statusCode)
        }
    }
    
    func download<T: APIRequest>(_ convertible: T) async throws -> Data {
        let request = try makeURLRequest(from: convertible)
        
        let (data, response) = try await URLSession.shared.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse else {
            throw NetworkError.invalidResponse
        }
        
        switch httpResponse.statusCode {
        case 200..<300:
            return data
        default:
            throw NetworkError.invalidStatusCode(httpResponse.statusCode)
        }
    }
    
    private func makeURLRequest<T: APIRequest>(from convertible: T) throws -> URLRequest {
        guard let baseURL = convertible.baseUrl ?? baseURL else {
            throw NetworkError.invalidURL
        }
        
        var url = baseURL
        
        if !convertible.endpoint.isEmpty {
            url = url.appendingPathComponent(convertible.endpoint)
        }
        
        if let parameters = convertible.parameters,
           var components = URLComponents(url: url, resolvingAgainstBaseURL: true) {
            components.queryItems = parameters.map { key, value in
                URLQueryItem(name: key, value: "\(value)")
            }
            if let finalURL = components.url {
                url = finalURL
            }
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = convertible.method.rawValue
        
        if convertible.bodyType == BodyType.multipart.rawValue, let body = convertible.multipartBody {
            let fBody = buildMultipartFormData(fields: body)
            request.httpBody = fBody.data
            request.setValue(fBody.contentType, forHTTPHeaderField: "Content-Type")
        } else if convertible.bodyType == BodyType.json.rawValue, let body = convertible.body {
            request.httpBody = try JSONSerialization.data(withJSONObject: body, options: [])
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        }
        
        if let headers = convertible.headers {
            for (key, value) in headers {
                request.setValue(value, forHTTPHeaderField: key)
            }
        }
        
        return request
    }
    
    private func buildMultipartFormData(fields: [MultipartFormField], boundary: String = UUID().uuidString) -> (data: Data, contentType: String) {
        var body = Data()
//        body.append(Data("--\(boundary)\r\n".utf8))
        for field in fields {
            switch field {
            case .text(let name, let value):
                body.append(Data("--\(boundary)\r\n".utf8))
                body.append(Data("Content-Disposition: form-data; name=\"\(name)\"\r\n\r\n".utf8))
                body.append(Data("\(value)\r\n".utf8))
            case .integer(let name, let value):
                   body.append(Data("--\(boundary)\r\n".utf8))
                   body.append(Data("Content-Disposition: form-data; name=\"\(name)\"\r\n\r\n".utf8))
                   body.append(Data("\(value)\r\n".utf8))
            case .file(let name, let fileName, let mimeType, let data):
                body.append(Data("--\(boundary)\r\n".utf8))
                body.append(Data("Content-Disposition: form-data; name=\"\(name)\"; filename=\"\(fileName)\"\r\n".utf8))
                body.append(Data("Content-Type: \(mimeType)\r\n\r\n".utf8))
                body.append(data)
                body.append(Data("\r\n".utf8))
            }
        }

        body.append(Data("--\(boundary)--\r\n".utf8))

        let contentType = "multipart/form-data; boundary=\(boundary)"
        return (body, contentType)
    }
}
