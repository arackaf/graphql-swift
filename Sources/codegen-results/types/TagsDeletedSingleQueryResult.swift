import Foundation
import graphql_swift

struct TagsDeletedSingleQueryResult: Codable {
    var TagsDeleted: TagsDeleted?
 
    enum Fields: String { case empty }
}

class TagsDeletedSingleQueryResultBuilder: GraphqlResults {
    private let resultsBuilder = GraphqlResultsBuilder<TagsDeletedSingleQueryResult.Fields>()
    
    init() {}
    init(_ name: String) {
        resultsBuilder.setName(name);
    }

    func emit() throws -> String {
        try resultsBuilder.emit()
    }

    
    @discardableResult
    func withTagsDeleted(_ build: (TagsDeletedBuilder) -> ()) -> Self {
        let res = TagsDeletedBuilder("TagsDeleted")
        build(res)
        resultsBuilder.addResultSet(res)

        return self
    }
}