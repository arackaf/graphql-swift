import Foundation
import graphql_swift

struct TagMutationResultMulti: Codable {
    var Tags: Array<Tag?>?
    var success: Bool?
    var Meta: MutationResultInfo?
 
    enum Fields: String {
        case success
    }
}

class TagMutationResultMultiBuilder: GraphqlResults {
    private let resultsBuilder = GraphqlResultsBuilder<TagMutationResultMulti.Fields>()
    
    init() {}
    init(_ name: String) {
        resultsBuilder.setName(name);
    }

    func emit() throws -> String {
        try resultsBuilder.emit()
    }

    @discardableResult
    func withFields(_ fields: TagMutationResultMulti.Fields...) -> Self {
        resultsBuilder.withFields(fields)
        return self
    }
    
    @discardableResult
    func withTags(_ build: (TagBuilder) -> ()) -> Self {
        let res = TagBuilder("Tags")
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