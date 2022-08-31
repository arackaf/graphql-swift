import Foundation
import graphql_swift

struct BookSummaryFilters: Codable {
    var title_contains: String?
    var title_startsWith: String?
    var title_endsWith: String?
    var title_regex: String?
    var title: String?
    var title_ne: String?
    var title_in: Array<String?>?
    var title_nin: Array<String?>?
    var asin: String?
    var asin_in: Array<String?>?
    var isbn: String?
    var isbn_in: Array<String?>?
    var smallImage_contains: String?
    var smallImage: String?
    var authors_count: Int?
    var authors_textContains: String?
    var authors_startsWith: String?
    var authors_endsWith: String?
    var authors_regex: String?
    var authors: Array<String?>?
    var authors_in: Array<Array<String?>?>?
    var authors_nin: Array<Array<String?>?>?
    var authors_contains: String?
    var authors_containsAny: Array<String?>?
    var authors_containsAll: Array<String?>?
    var authors_ne: Array<String?>?
    var OR: Array<BookSummaryFilters?>?
}