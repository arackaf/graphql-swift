import Foundation
import graphql_swift

struct TagInput: Codable {
    var _id: String?
    var name: String
    var path: String?
    var userId: String?
    var backgroundColor: String
    var textColor: String
    var timestamp: Float?
}