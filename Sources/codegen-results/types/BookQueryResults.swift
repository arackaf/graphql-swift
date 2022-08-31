import Foundation
import graphql_swift

struct BookQueryResults: Codable {
    var Books: Array<Book>?
    var Meta: QueryResultsMetadata?
 
    enum Fields: String { case empty }
}

class BookQueryResultsBuilder: GraphqlResults {
    private let resultsBuilder = GraphqlResultsBuilder<BookQueryResults.Fields>()
    
    init() {}
    init(_ name: String) {
        resultsBuilder.setName(name);
    }

    func emit() throws -> String {
        try resultsBuilder.emit()
    }

    
    @discardableResult
    func withBooks(_ build: (BookBuilder) -> ()) -> Self {
        let res = BookBuilder("Books")
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