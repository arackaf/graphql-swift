import Foundation
import graphql_swift

struct BookSort: Codable {
    var _id: Int?
    var ean: Int?
    var isbn: Int?
    var title: Int?
    var mobileImage: Int?
    var smallImage: Int?
    var mediumImage: Int?
    var userId: Int?
    var publisher: Int?
    var publicationDate: Int?
    var pages: Int?
    var authors: Int?
    var subjects: Int?
    var tags: Int?
    var isRead: Int?
    var dateAdded: Int?
    var editorialReviews: Int?
    var similarItems: Int?
    var similarItemsLastUpdate: Int?
    var timestamp: Int?
}