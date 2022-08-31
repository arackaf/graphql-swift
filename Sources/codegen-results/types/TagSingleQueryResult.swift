import Foundation
import graphql_swift

struct TagSingleQueryResult: Codable {
    var Tag: Tag?
 
    enum Fields: String { case empty }
}

class TagSingleQueryResultBuilder: GraphqlResults {
    private let resultsBuilder = GraphqlResultsBuilder<TagSingleQueryResult.Fields>()
    
    init() {}
    init(_ name: String) {
        resultsBuilder.setName(name);
    }

    func emit() throws -> String {
        try resultsBuilder.emit()
    }

    
    @discardableResult
    func withTag(_ build: (TagBuilder) -> ()) -> Self {
        let res = TagBuilder("Tag")
        build(res)
        resultsBuilder.addResultSet(res)

        return self
    }
}