import Foundation
import graphql_swift

struct BookSummaryMutationResult: Codable {
    var BookSummary: BookSummary?
    var success: Bool?
    var Meta: MutationResultInfo?
 
    enum Fields: String {
        case success
    }
}

class BookSummaryMutationResultBuilder: GraphqlResults {
    private let resultsBuilder = GraphqlResultsBuilder<BookSummaryMutationResult.Fields>()
    
    init() {}
    init(_ name: String) {
        resultsBuilder.setName(name);
    }

    func emit() throws -> String {
        try resultsBuilder.emit()
    }

    @discardableResult
    func withFields(_ fields: BookSummaryMutationResult.Fields...) -> Self {
        resultsBuilder.withFields(fields)
        return self
    }
    
    @discardableResult
    func withBookSummary(_ build: (BookSummaryBuilder) -> ()) -> Self {
        let res = BookSummaryBuilder("BookSummary")
        build(res)
        resultsBuilder.addResultSet(res)

        return self
    }
    
    @discardableResult
    func withMeta(_ build: (MutationResultInfoBuilder) -> ()) -> Self {
        let res = MutationResultInfoBuilder("Meta")
        build(res)
        resultsBuilder.addResultSet(res)

        return self
    }
}