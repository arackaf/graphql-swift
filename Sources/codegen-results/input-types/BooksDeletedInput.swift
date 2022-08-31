import Foundation
import graphql_swift

struct BooksDeletedInput: Codable {
    var _id: String?
    var userId: String?
    var deletedTimestamp: Float?
}