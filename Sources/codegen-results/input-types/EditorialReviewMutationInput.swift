import Foundation
import graphql_swift

struct EditorialReviewMutationInput: Codable {
    var source: String?
    var content: String?
}