import Foundation
import graphql_swift

struct TagsDeletedMutationInput: Codable {
    var userId: String?
    var deletedTimestamp: Float?
    var deletedTimestamp_INC: Int?
    var deletedTimestamp_DEC: Int?
}