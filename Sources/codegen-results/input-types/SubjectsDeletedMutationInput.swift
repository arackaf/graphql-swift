import Foundation
import graphql_swift

struct SubjectsDeletedMutationInput: Codable {
    var userId: String?
    var deletedTimestamp: Float?
    var deletedTimestamp_INC: Int?
    var deletedTimestamp_DEC: Int?
}