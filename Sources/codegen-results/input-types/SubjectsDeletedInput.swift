import Foundation
import graphql_swift

struct SubjectsDeletedInput: Codable {
    var _id: String?
    var userId: String?
    var deletedTimestamp: Float?
}