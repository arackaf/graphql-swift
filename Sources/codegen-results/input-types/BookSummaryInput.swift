import Foundation
import graphql_swift

struct BookSummaryInput: Codable {
    var _id: String?
    var title: String?
    var asin: String?
    var isbn: String?
    var ean: String?
    var smallImage: String?
    var smallImagePreview: JSON?
    var mediumImage: String?
    var mediumImagePreview: JSON?
    var authors: Array<String?>?
}