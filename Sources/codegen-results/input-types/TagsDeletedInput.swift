import Foundation
import graphql_swift

struct TagsDeletedInput: Codable {
    var _id: String?
    var userId: String?
    var deletedTimestamp: Float?
}