import Foundation

enum NetworkRequestError: Error {
    case NoResponse
    case NonHttpResponse(URLResponse)
    case BadResponseCode(Int)
}

func networkRequest(_ request: URLRequest) async throws -> Data {
    return try await withUnsafeThrowingContinuation { cont in
        print("about to request")
        URLSession.shared.dataTask(with: request) { data, response, error in
            print("Some response")
            if let error = error {
                print("error", error)
                cont.resume(throwing: error)
                return
            }
            guard let response = response else {
                print("A")
                return cont.resume(throwing: NetworkRequestError.NoResponse)
            }
            guard let response = response as? HTTPURLResponse else {
                print("B")
                return cont.resume(throwing: NetworkRequestError.NonHttpResponse(response))
            }
            if !(200 ..< 299).contains(response.statusCode) {
                return cont.resume(throwing: NetworkRequestError.BadResponseCode(response.statusCode))
            }
            
            if let data = data {
                print("Ayyyyy")
                print(data)
                cont.resume(returning: data)
            }
        }.resume()
        print("after resume")
    }
}
