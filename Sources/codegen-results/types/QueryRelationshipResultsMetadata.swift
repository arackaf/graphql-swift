import Foundation
import graphql_swift

struct QueryRelationshipResultsMetadata: Codable {
    var count: Int?
 
    enum Fields: String {
        case count
    }
}

class QueryRelationshipResultsMetadataBuilder: GraphqlResults {
    private let resultsBuilder = GraphqlResultsBuilder<QueryRelationshipResultsMetadata.Fields>()
    
    init() {}
    init(_ name: String) {
        resultsBuilder.setName(name);
    }

    func emit() throws -> String {
        try resultsBuilder.emit()
    }

    @discardableResult
    func withFields(_ fields: QueryRelationshipResultsMetadata.Fields...) -> Self {
        resultsBuilder.withFields(fields)
        return self
    }

}