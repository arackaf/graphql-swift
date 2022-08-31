import Foundation
import graphql_swift

struct LabelColorInput: Codable {
    var _id: String?
    var backgroundColor: String
    var order: Int
}