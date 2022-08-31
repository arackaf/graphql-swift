import Foundation
import graphql_swift

struct DynamoKey: Codable {
    var pk: String?
    var sk: String?
 
    enum Fields: String {
        case pk
        case sk
    }
}

class DynamoKeyBuilder: GraphqlResults {
    private let resultsBuilder = GraphqlResultsBuilder<DynamoKey.Fields>()
    
    init() {}
    init(_ name: String) {
        resultsBuilder.setName(name);
    }

    func emit() throws -> String {
        try resultsBuilder.emit()
    }

    @discardableResult
    func withFields(_ fields: DynamoKey.Fields...) -> Self {
        resultsBuilder.withFields(fields)
        return self
    }

}