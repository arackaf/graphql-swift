import Foundation
import graphql_swift

struct BookSingleQueryResult: Codable {
    var Book: Book?
 
    enum Fields: String { case empty }
}

class BookSingleQueryResultBuilder: GraphqlResults {
    private let resultsBuilder = GraphqlResultsBuilder<BookSingleQueryResult.Fields>()
    
    init() {}
    init(_ name: String) {
        resultsBuilder.setName(name);
    }

    func emit() throws -> String {
        try resultsBuilder.emit()
    }

    
    @discardableResult
    func withBook(_ build: (BookBuilder) -> ()) -> Self {
        let res = BookBuilder("Book")
        build(res)
        resultsBuilder.addResultSet(res)

        return self
    }
}