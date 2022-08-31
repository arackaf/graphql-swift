import Foundation
import graphql_swift

struct DynamoKeyInput: Codable {
    var pk: String?
    var sk: String?
}