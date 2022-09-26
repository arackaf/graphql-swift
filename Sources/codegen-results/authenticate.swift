import Foundation

struct Login: Codable {
    let email: String
    let password: String
}

enum AuthError: Error {
    case LoginJsonSerialization
    case NoData
    case BadResponse
    case CantDecodeResponse
    case NoLoginToken
}

func authenticate() async throws -> String {
    let loginUrl = URL(string: "https://mylibrary.io/login-ios")!
    let login = Login(email: username, password: password);
    
    guard let loginRequestPacket = try? JSONEncoder().encode(login) else {
        throw AuthError.LoginJsonSerialization
    }
    
    var loginTokenRequest = URLRequest(url: loginUrl)
    loginTokenRequest.httpMethod = "POST"
    loginTokenRequest.setValue("application/json", forHTTPHeaderField: "Content-Type") // the request is JSON
    loginTokenRequest.setValue("application/json", forHTTPHeaderField: "Accept") // the response expected to be in JSON format
    loginTokenRequest.httpBody = loginRequestPacket
    
    let (data, response) = try await URLSession.shared.data(for: loginTokenRequest)
    
    guard let response = response as? HTTPURLResponse, (200 ..< 299) ~= response.statusCode else {
        throw AuthError.BadResponse
    }
    
    guard let jsonObject = try JSONSerialization.jsonObject(with: data) as? [String: Any] else {
        throw AuthError.CantDecodeResponse
    }

    guard let loginToken = jsonObject["loginToken"] as? String else {
        throw AuthError.NoLoginToken
    }

    return loginToken
}
