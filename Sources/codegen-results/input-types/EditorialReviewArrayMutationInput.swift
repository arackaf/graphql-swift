import Foundation
import graphql_swift

struct EditorialReviewArrayMutationInput: Codable {
    var index: Int?
    var Updates: EditorialReviewMutationInput?
}