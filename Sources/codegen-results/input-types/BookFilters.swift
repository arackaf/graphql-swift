import Foundation
import graphql_swift

struct BookFilters: Codable {
    var isbn: String?
    var isbn_in: Array<String?>?
    var title_contains: String?
    var userId: String?
    var userId_in: Array<String?>?
    var publisher_contains: String?
    var publisher: String?
    var publisher_in: Array<String?>?
    var pages_lt: Int?
    var pages_gt: Int?
    var pages: Int?
    var authors_textContains: String?
    var authors_in: Array<Array<String?>?>?
    var subjects_count: Int?
    var subjects_containsAny: Array<String?>?
    var tags_containsAny: Array<String?>?
    var isRead: Bool?
    var isRead_ne: Bool?
    var timestamp_lt: Float?
    var timestamp_lte: Float?
    var timestamp_gt: Float?
    var timestamp_gte: Float?
    var OR: Array<BookFilters?>?
}