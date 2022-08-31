import Foundation
import graphql_swift

struct BookMutationResult: Codable {
    var Book: Book?
    var success: Bool?
    var Meta: MutationResultInfo?
 
    enum Fields: String {
        case success
    }
}

class BookMutationResultBuilder: GraphqlResults {
    private let resultsBuilder = GraphqlResultsBuilder<BookMutationResult.Fields>()
    
    init() {}
    init(_ name: String) {
        resultsBuilder.setName(name);
    }

    func emit() throws -> String {
        try resultsBuilder.emit()
    }

    @discardableResult
    func withFields(_ fields: BookMutationResult.Fields...) -> Self {
        resultsBuilder.withFields(fields)
        return self
    }
    
    @discardableResult
    func withBook(_ build: (BookBuilder) -> ()) -> Self {
        let res = BookBuilder("Book")
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