import Foundation
import graphql_swift

struct TagsDeletedQueryResults: Codable {
    var TagsDeleteds: Array<TagsDeleted>?
    var Meta: QueryResultsMetadata?
 
    enum Fields: String { case empty }
}

class TagsDeletedQueryResultsBuilder: GraphqlResults {
    private let resultsBuilder = GraphqlResultsBuilder<TagsDeletedQueryResults.Fields>()
    
    init() {}
    init(_ name: String) {
        resultsBuilder.setName(name);
    }

    func emit() throws -> String {
        try resultsBuilder.emit()
    }

    
    @discardableResult
    func withTagsDeleteds(_ build: (TagsDeletedBuilder) -> ()) -> Self {
        let res = TagsDeletedBuilder("TagsDeleteds")
        build(res)
        resultsBuilder.addResultSet(res)

        return self
    }
    
    @discardableResult
    func withMeta(_ build: (QueryResultsMetadataBuilder) -> ()) -> Self {
        let res = QueryResultsMetadataBuilder("Meta")
        build(res)
        resultsBuilder.addResultSet(res)

        return self
    }
}