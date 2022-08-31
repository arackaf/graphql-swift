import Foundation
import graphql_swift

struct BookInput: Codable {
    var _id: String?
    var ean: String?
    var isbn: String?
    var title: String
    var mobileImage: String?
    var mobileImagePreview: JSON?
    var smallImage: String?
    var smallImagePreview: JSON?
    var mediumImage: String?
    var mediumImagePreview: JSON?
    var userId: String?
    var publisher: String?
    var publicationDate: String?
    var pages: Int?
    var authors: Array<String?>?
    var subjects: Array<String?>?
    var tags: Array<String?>?
    var isRead: Bool?
    var dateAdded: String?
    var editorialReviews: Array<EditorialReviewInput?>?
    var similarItems: Array<String?>?
    var similarItemsLastUpdate: Int?
    var timestamp: Float?
    var similarBooks: Array<BookSummaryInput?>?
}