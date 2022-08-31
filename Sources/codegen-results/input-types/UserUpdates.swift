import Foundation
import graphql_swift

struct UserUpdates: Codable {
    var isPublic: Bool?
    var publicBooksHeader: String?
    var publicName: String?
}