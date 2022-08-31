import Foundation
import graphql_swift

struct QueryResultsMetadata: Codable {
    var count: Int?
 
    enum Fields: String {
        case count
    }
}

class QueryResultsMetadataBuilder: GraphqlResults {
    private let resultsBuilder = GraphqlResultsBuilder<QueryResultsMetadata.Fields>()
    
    init() {}
    init(_ name: String) {
        resultsBuilder.setName(name);
    }

    func emit() throws -> String {
        try resultsBuilder.emit()
    }

    @discardableResult
    func withFields(_ fields: QueryResultsMetadata.Fields...) -> Self {
        resultsBuilder.withFields(fields)
        return self
    }

}