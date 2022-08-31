import Foundation
import graphql_swift

struct BookSummaryQueryResults: Codable {
    var BookSummarys: Array<BookSummary>?
    var Meta: QueryResultsMetadata?
 
    enum Fields: String { case empty }
}

class BookSummaryQueryResultsBuilder: GraphqlResults {
    private let resultsBuilder = GraphqlResultsBuilder<BookSummaryQueryResults.Fields>()
    
    init() {}
    init(_ name: String) {
        resultsBuilder.setName(name);
    }

    func emit() throws -> String {
        try resultsBuilder.emit()
    }

    
    @discardableResult
    func withBookSummarys(_ build: (BookSummaryBuilder) -> ()) -> Self {
        let res = BookSummaryBuilder("BookSummarys")
        build(res)
        resultsBuilder.addResultSet(res)

        return self
    }
    
    @discardableResult
    func withMeta(_ build: (QueryResultsMetadataBuilder) -> ()) -> Self {
        let res = QueryResultsMetadataBuilder("Meta")
        build(res)
        resultsBuilder.addResultSet(res)

        return self
    }
}