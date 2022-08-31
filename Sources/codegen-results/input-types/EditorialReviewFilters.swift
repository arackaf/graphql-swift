import Foundation
import graphql_swift

struct EditorialReviewFilters: Codable {
    var source_contains: String?
    var source_startsWith: String?
    var source_endsWith: String?
    var source_regex: String?
    var source: String?
    var source_ne: String?
    var source_in: Array<String?>?
    var source_nin: Array<String?>?
    var content_contains: String?
    var content_startsWith: String?
    var content_endsWith: String?
    var content_regex: String?
    var content: String?
    var content_ne: String?
    var content_in: Array<String?>?
    var content_nin: Array<String?>?
    var OR: Array<EditorialReviewFilters?>?
}