import Foundation
import graphql_swift

struct TagsDeletedMutationResult: Codable {
    var TagsDeleted: TagsDeleted?
    var success: Bool?
    var Meta: MutationResultInfo?
 
    enum Fields: String {
        case success
    }
}

class TagsDeletedMutationResultBuilder: GraphqlResults {
    private let resultsBuilder = GraphqlResultsBuilder<TagsDeletedMutationResult.Fields>()
    
    init() {}
    init(_ name: String) {
        resultsBuilder.setName(name);
    }

    func emit() throws -> String {
        try resultsBuilder.emit()
    }

    @discardableResult
    func withFields(_ fields: TagsDeletedMutationResult.Fields...) -> Self {
        resultsBuilder.withFields(fields)
        return self
    }
    
    @discardableResult
    func withTagsDeleted(_ build: (TagsDeletedBuilder) -> ()) -> Self {
        let res = TagsDeletedBuilder("TagsDeleted")
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