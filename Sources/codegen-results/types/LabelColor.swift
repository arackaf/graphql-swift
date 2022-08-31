import Foundation
import graphql_swift

struct LabelColor: Codable {
    var _id: String?
    var backgroundColor: String?
    var order: Int?
 
    enum Fields: String {
        case _id
        case backgroundColor
        case order
    }
}

class LabelColorBuilder: GraphqlResults {
    private let resultsBuilder = GraphqlResultsBuilder<LabelColor.Fields>()
    
    init() {}
    init(_ name: String) {
        resultsBuilder.setName(name);
    }

    func emit() throws -> String {
        try resultsBuilder.emit()
    }

    @discardableResult
    func withFields(_ fields: LabelColor.Fields...) -> Self {
        resultsBuilder.withFields(fields)
        return self
    }

}