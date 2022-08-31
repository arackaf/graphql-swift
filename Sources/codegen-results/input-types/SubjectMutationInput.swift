import Foundation
import graphql_swift

struct SubjectMutationInput: Codable {
    var name: String?
    var path: String?
    var userId: String?
    var backgroundColor: String?
    var textColor: String?
    var timestamp: Float?
    var timestamp_INC: Int?
    var timestamp_DEC: Int?
}