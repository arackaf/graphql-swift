import Foundation
import graphql_swift

struct BookSummaryMutationInput: Codable {
    var title: String?
    var asin: String?
    var isbn: String?
    var ean: String?
    var smallImage: String?
    var smallImagePreview: JSON?
    var mediumImage: String?
    var mediumImagePreview: JSON?
    var authors: Array<String?>?
    var authors_PUSH: String?
    var authors_CONCAT: Array<String?>?
    var authors_UPDATE: StringArrayUpdate?
    var authors_UPDATES: Array<StringArrayUpdate?>?
    var authors_PULL: Array<String?>?
    var authors_ADDTOSET: Array<String?>?
}