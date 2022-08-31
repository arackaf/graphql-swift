import Foundation
import graphql_swift

struct BookSummaryMutationResultMulti: Codable {
    var BookSummarys: Array<BookSummary?>?
    var success: Bool?
    var Meta: MutationResultInfo?
 
    enum Fields: String {
        case success
    }
}

class BookSummaryMutationResultMultiBuilder: GraphqlResults {
    private let resultsBuilder = GraphqlResultsBuilder<BookSummaryMutationResultMulti.Fields>()
    
    init() {}
    init(_ name: String) {
        resultsBuilder.setName(name);
    }

    func emit() throws -> String {
        try resultsBuilder.emit()
    }

    @discardableResult
    func withFields(_ fields: BookSummaryMutationResultMulti.Fields...) -> Self {
        resultsBuilder.withFields(fields)
        return self
    }
    
    @discardableResult
    func withBookSummarys(_ build: (BookSummaryBuilder) -> ()) -> Self {
        let res = BookSummaryBuilder("BookSummarys")
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