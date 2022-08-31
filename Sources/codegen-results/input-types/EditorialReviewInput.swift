import Foundation
import graphql_swift

struct EditorialReviewInput: Codable {
    var source: String?
    var content: String?
}