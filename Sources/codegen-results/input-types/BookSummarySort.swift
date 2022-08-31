import Foundation
import graphql_swift

struct BookSummarySort: Codable {
    var _id: Int?
    var title: Int?
    var asin: Int?
    var isbn: Int?
    var ean: Int?
    var smallImage: Int?
    var mediumImage: Int?
    var authors: Int?
}