import Foundation
import graphql_swift

struct BooksDeletedSingleQueryResult: Codable {
    var BooksDeleted: BooksDeleted?
 
    enum Fields: String { case empty }
}

class BooksDeletedSingleQueryResultBuilder: GraphqlResults {
    private let resultsBuilder = GraphqlResultsBuilder<BooksDeletedSingleQueryResult.Fields>()
    
    init() {}
    init(_ name: String) {
        resultsBuilder.setName(name);
    }

    func emit() throws -> String {
        try resultsBuilder.emit()
    }

    
    @discardableResult
    func withBooksDeleted(_ build: (BooksDeletedBuilder) -> ()) -> Self {
        let res = BooksDeletedBuilder("BooksDeleted")
        build(res)
        resultsBuilder.addResultSet(res)

        return self
    }
}