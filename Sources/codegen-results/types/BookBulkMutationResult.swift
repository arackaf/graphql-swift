import Foundation
import graphql_swift

struct BookBulkMutationResult: Codable {
    var success: Bool?
    var Meta: MutationResultInfo?
 
    enum Fields: String {
        case success
    }
}

class BookBulkMutationResultBuilder: GraphqlResults {
    private let resultsBuilder = GraphqlResultsBuilder<BookBulkMutationResult.Fields>()
    
    init() {}
    init(_ name: String) {
        resultsBuilder.setName(name);
    }

    func emit() throws -> String {
        try resultsBuilder.emit()
    }

    @discardableResult
    func withFields(_ fields: BookBulkMutationResult.Fields...) -> Self {
        resultsBuilder.withFields(fields)
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