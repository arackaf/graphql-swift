import Foundation
import graphql_swift

struct BooksDeletedQueryResults: Codable {
    var BooksDeleteds: Array<BooksDeleted>?
    var Meta: QueryResultsMetadata?
 
    enum Fields: String { case empty }
}

class BooksDeletedQueryResultsBuilder: GraphqlResults {
    private let resultsBuilder = GraphqlResultsBuilder<BooksDeletedQueryResults.Fields>()
    
    init() {}
    init(_ name: String) {
        resultsBuilder.setName(name);
    }

    func emit() throws -> String {
        try resultsBuilder.emit()
    }

    
    @discardableResult
    func withBooksDeleteds(_ build: (BooksDeletedBuilder) -> ()) -> Self {
        let res = BooksDeletedBuilder("BooksDeleteds")
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