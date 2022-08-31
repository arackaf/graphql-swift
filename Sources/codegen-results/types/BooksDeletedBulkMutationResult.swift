import Foundation
import graphql_swift

struct BooksDeletedBulkMutationResult: Codable {
    var success: Bool?
    var Meta: MutationResultInfo?
 
    enum Fields: String {
        case success
    }
}

class BooksDeletedBulkMutationResultBuilder: GraphqlResults {
    private let resultsBuilder = GraphqlResultsBuilder<BooksDeletedBulkMutationResult.Fields>()
    
    init() {}
    init(_ name: String) {
        resultsBuilder.setName(name);
    }

    func emit() throws -> String {
        try resultsBuilder.emit()
    }

    @discardableResult
    func withFields(_ fields: BooksDeletedBulkMutationResult.Fields...) -> Self {
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