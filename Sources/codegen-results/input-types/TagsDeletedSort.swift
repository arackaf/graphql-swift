import Foundation
import graphql_swift

struct TagsDeletedSort: Codable {
    var _id: Int?
    var userId: Int?
    var deletedTimestamp: Int?
}