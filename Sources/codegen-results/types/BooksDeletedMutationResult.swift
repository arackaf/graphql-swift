import Foundation
import graphql_swift

struct BooksDeletedMutationResult: Codable {
    var BooksDeleted: BooksDeleted?
    var success: Bool?
    var Meta: MutationResultInfo?
 
    enum Fields: String {
        case success
    }
}

class BooksDeletedMutationResultBuilder: GraphqlResults {
    private let resultsBuilder = GraphqlResultsBuilder<BooksDeletedMutationResult.Fields>()
    
    init() {}
    init(_ name: String) {
        resultsBuilder.setName(name);
    }

    func emit() throws -> String {
        try resultsBuilder.emit()
    }

    @discardableResult
    func withFields(_ fields: BooksDeletedMutationResult.Fields...) -> Self {
        resultsBuilder.withFields(fields)
        return self
    }
    
    @discardableResult
    func withBooksDeleted(_ build: (BooksDeletedBuilder) -> ()) -> Self {
        let res = BooksDeletedBuilder("BooksDeleted")
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