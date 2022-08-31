import Foundation
import graphql_swift

struct BookSummarySingleQueryResult: Codable {
    var BookSummary: BookSummary?
 
    enum Fields: String { case empty }
}

class BookSummarySingleQueryResultBuilder: GraphqlResults {
    private let resultsBuilder = GraphqlResultsBuilder<BookSummarySingleQueryResult.Fields>()
    
    init() {}
    init(_ name: String) {
        resultsBuilder.setName(name);
    }

    func emit() throws -> String {
        try resultsBuilder.emit()
    }

    
    @discardableResult
    func withBookSummary(_ build: (BookSummaryBuilder) -> ()) -> Self {
        let res = BookSummaryBuilder("BookSummary")
        build(res)
        resultsBuilder.addResultSet(res)

        return self
    }
}