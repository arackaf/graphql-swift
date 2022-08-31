import Foundation
import graphql_swift

struct LabelColorSingleQueryResult: Codable {
    var LabelColor: LabelColor?
 
    enum Fields: String { case empty }
}

class LabelColorSingleQueryResultBuilder: GraphqlResults {
    private let resultsBuilder = GraphqlResultsBuilder<LabelColorSingleQueryResult.Fields>()
    
    init() {}
    init(_ name: String) {
        resultsBuilder.setName(name);
    }

    func emit() throws -> String {
        try resultsBuilder.emit()
    }

    
    @discardableResult
    func withLabelColor(_ build: (LabelColorBuilder) -> ()) -> Self {
        let res = LabelColorBuilder("LabelColor")
        build(res)
        resultsBuilder.addResultSet(res)

        return self
    }
}