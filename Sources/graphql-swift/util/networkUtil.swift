import Foundation

enum NetworkRequestError: Error {
    case NoResponse
    case NonHttpResponse(URLResponse)
    case BadResponseCode(Int)
    case BadData
    case NonJsonResponse
}

func networkRequest(_ request: URLRequest) async throws -> Data? {
    return try await withUnsafeThrowingContinuation { cont in
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                cont.resume(throwing: error)
                return
            }
            guard let response = response else {
                return cont.resume(throwing: NetworkRequestError.NoResponse)
            }
            guard let response = response as? HTTPURLResponse else {
                return cont.resume(throwing: NetworkRequestError.NonHttpResponse(response))
            }
            if !(200 ..< 299).contains(response.statusCode) {
                return cont.resume(throwing: NetworkRequestError.BadResponseCode(response.statusCode))
            }
            
            return cont.resume(returning: data)
        }.resume()
    }
}

func jsonRequest(_ request: URLRequest) async throws -> [String: Any] {
    let data = try await networkRequest(request)
    
    guard let data = data else {
        throw NetworkRequestError.BadData
    }
    guard let jsonObject = try? JSONSerialization.jsonObject(with: data) as? [String: Any] else {
        print("Error: Cannot convert data to JSON object")
        
        throw NetworkRequestError.NonJsonResponse
    }
    
    return jsonObject
}
