import Foundation
import graphql_swift

struct SubjectBulkMutationResult: Codable {
    var success: Bool?
    var Meta: MutationResultInfo?
 
    enum Fields: String {
        case success
    }
}

class SubjectBulkMutationResultBuilder: GraphqlResults {
    private let resultsBuilder = GraphqlResultsBuilder<SubjectBulkMutationResult.Fields>()
    
    init() {}
    init(_ name: String) {
        resultsBuilder.setName(name);
    }

    func emit() throws -> String {
        try resultsBuilder.emit()
    }

    @discardableResult
    func withFields(_ fields: SubjectBulkMutationResult.Fields...) -> Self {
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