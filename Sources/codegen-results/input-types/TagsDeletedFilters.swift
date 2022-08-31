import Foundation
import graphql_swift

struct TagsDeletedFilters: Codable {
    var _id: String?
    var _id_ne: String?
    var _id_in: Array<String?>?
    var _id_nin: Array<String?>?
    var userId_contains: String?
    var userId_startsWith: String?
    var userId_endsWith: String?
    var userId_regex: String?
    var userId: String?
    var userId_ne: String?
    var userId_in: Array<String?>?
    var userId_nin: Array<String?>?
    var deletedTimestamp_lt: Float?
    var deletedTimestamp_gt: Float?
    var OR: Array<TagsDeletedFilters?>?
}