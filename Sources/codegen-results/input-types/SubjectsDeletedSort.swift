import Foundation
import graphql_swift

struct SubjectsDeletedSort: Codable {
    var _id: Int?
    var userId: Int?
    var deletedTimestamp: Int?
}