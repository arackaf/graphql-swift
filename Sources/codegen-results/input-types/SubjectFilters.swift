import Foundation
import graphql_swift

struct SubjectFilters: Codable {
    var name_contains: String?
    var name_startsWith: String?
    var name_endsWith: String?
    var name_regex: String?
    var name: String?
    var name_ne: String?
    var name_in: Array<String?>?
    var name_nin: Array<String?>?
    var path_contains: String?
    var path_startsWith: String?
    var path: String?
    var userId: String?
    var userId_in: Array<String?>?
    var timestamp_lt: Float?
    var timestamp_gt: Float?
    var OR: Array<SubjectFilters?>?
}