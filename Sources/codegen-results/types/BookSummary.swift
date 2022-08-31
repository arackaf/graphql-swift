import Foundation
import graphql_swift

struct BookSummary: Codable {
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
 
    enum Fields: String {
        case _id
        case title
        case asin
        case isbn
        case ean
        case smallImage
        case smallImagePreview
        case mediumImage
        case mediumImagePreview
        case authors
    }
}

class BookSummaryBuilder: GraphqlResults {
    private let resultsBuilder = GraphqlResultsBuilder<BookSummary.Fields>()
    
    init() {}
    init(_ name: String) {
        resultsBuilder.setName(name);
    }

    func emit() throws -> String {
        try resultsBuilder.emit()
    }

    @discardableResult
    func withFields(_ fields: BookSummary.Fields...) -> Self {
        resultsBuilder.withFields(fields)
        return self
    }

}