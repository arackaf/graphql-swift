import Foundation
import graphql_swift

struct BookMutationResultMulti: Codable {
    var Books: Array<Book?>?
    var success: Bool?
    var Meta: MutationResultInfo?
 
    enum Fields: String {
        case success
    }
}

class BookMutationResultMultiBuilder: GraphqlResults {
    private let resultsBuilder = GraphqlResultsBuilder<BookMutationResultMulti.Fields>()
    
    init() {}
    init(_ name: String) {
        resultsBuilder.setName(name);
    }

    func emit() throws -> String {
        try resultsBuilder.emit()
    }

    @discardableResult
    func withFields(_ fields: BookMutationResultMulti.Fields...) -> Self {
        resultsBuilder.withFields(fields)
        return self
    }
    
    @discardableResult
    func withBooks(_ build: (BookBuilder) -> ()) -> Self {
        let res = BookBuilder("Books")
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