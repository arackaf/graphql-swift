import Foundation
import graphql_swift

struct LabelColorMutationResult: Codable {
    var LabelColor: LabelColor?
    var success: Bool?
    var Meta: MutationResultInfo?
 
    enum Fields: String {
        case success
    }
}

class LabelColorMutationResultBuilder: GraphqlResults {
    private let resultsBuilder = GraphqlResultsBuilder<LabelColorMutationResult.Fields>()
    
    init() {}
    init(_ name: String) {
        resultsBuilder.setName(name);
    }

    func emit() throws -> String {
        try resultsBuilder.emit()
    }

    @discardableResult
    func withFields(_ fields: LabelColorMutationResult.Fields...) -> Self {
        resultsBuilder.withFields(fields)
        return self
    }
    
    @discardableResult
    func withLabelColor(_ build: (LabelColorBuilder) -> ()) -> Self {
        let res = LabelColorBuilder("LabelColor")
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