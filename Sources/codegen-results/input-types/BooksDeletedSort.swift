import Foundation
import graphql_swift

struct BooksDeletedSort: Codable {
    var _id: Int?
    var userId: Int?
    var deletedTimestamp: Int?
}