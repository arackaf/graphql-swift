import Foundation
import graphql_swift

struct LabelColorMutationInput: Codable {
    var backgroundColor: String?
    var order: Int?
    var order_INC: Int?
    var order_DEC: Int?
}