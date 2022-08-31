import Foundation
import graphql_swift

struct Book: Codable {
    var _id: String?
    var ean: String?
    var isbn: String?
    var title: String?
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
    var editorialReviews: Array<EditorialReview?>?
    var similarItems: Array<String?>?
    var similarItemsLastUpdate: Int?
    var timestamp: Float?
    var similarBooks: Array<BookSummary>?
    var similarBooksMeta: QueryRelationshipResultsMetadata?
 
    enum Fields: String {
        case _id
        case ean
        case isbn
        case title
        case mobileImage
        case mobileImagePreview
        case smallImage
        case smallImagePreview
        case mediumImage
        case mediumImagePreview
        case userId
        case publisher
        case publicationDate
        case pages
        case authors
        case subjects
        case tags
        case isRead
        case dateAdded
        case similarItems
        case similarItemsLastUpdate
        case timestamp
    }
}

class BookBuilder: GraphqlResults {
    private let resultsBuilder = GraphqlResultsBuilder<Book.Fields>()
    
    init() {}
    init(_ name: String) {
        resultsBuilder.setName(name);
    }

    func emit() throws -> String {
        try resultsBuilder.emit()
    }

    @discardableResult
    func withFields(_ fields: Book.Fields...) -> Self {
        resultsBuilder.withFields(fields)
        return self
    }
    
    @discardableResult
    func withEditorialReviews(_ build: (EditorialReviewBuilder) -> ()) -> Self {
        let res = EditorialReviewBuilder("editorialReviews")
        build(res)
        resultsBuilder.addResultSet(res)

        return self
    }
    
    @discardableResult
    func withSimilarBooks(_ build: (BookSummaryBuilder) -> ()) -> Self {
        let res = BookSummaryBuilder("similarBooks")
        build(res)
        resultsBuilder.addResultSet(res)

        return self
    }
    
    @discardableResult
    func withSimilarBooksMeta(_ build: (QueryRelationshipResultsMetadataBuilder) -> ()) -> Self {
        let res = QueryRelationshipResultsMetadataBuilder("similarBooksMeta")
        build(res)
        resultsBuilder.addResultSet(res)

        return self
    }
}