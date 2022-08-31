import Foundation
import graphql_swift

struct TagQueryResults: Codable {
    var Tags: Array<Tag>?
    var Meta: QueryResultsMetadata?
 
    enum Fields: String { case empty }
}

class TagQueryResultsBuilder: GraphqlResults {
    private let resultsBuilder = GraphqlResultsBuilder<TagQueryResults.Fields>()
    
    init() {}
    init(_ name: String) {
        resultsBuilder.setName(name);
    }

    func emit() throws -> String {
        try resultsBuilder.emit()
    }

    
    @discardableResult
    func withTags(_ build: (TagBuilder) -> ()) -> Self {
        let res = TagBuilder("Tags")
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