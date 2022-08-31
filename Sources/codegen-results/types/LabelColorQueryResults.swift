import Foundation
import graphql_swift

struct LabelColorQueryResults: Codable {
    var LabelColors: Array<LabelColor>?
    var Meta: QueryResultsMetadata?
 
    enum Fields: String { case empty }
}

class LabelColorQueryResultsBuilder: GraphqlResults {
    private let resultsBuilder = GraphqlResultsBuilder<LabelColorQueryResults.Fields>()
    
    init() {}
    init(_ name: String) {
        resultsBuilder.setName(name);
    }

    func emit() throws -> String {
        try resultsBuilder.emit()
    }

    
    @discardableResult
    func withLabelColors(_ build: (LabelColorBuilder) -> ()) -> Self {
        let res = LabelColorBuilder("LabelColors")
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