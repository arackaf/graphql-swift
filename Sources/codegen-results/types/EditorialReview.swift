import Foundation
import graphql_swift

struct EditorialReview: Codable {
    var source: String?
    var content: String?
 
    enum Fields: String {
        case source
        case content
    }
}

class EditorialReviewBuilder: GraphqlResults {
    private let resultsBuilder = GraphqlResultsBuilder<EditorialReview.Fields>()
    
    init() {}
    init(_ name: String) {
        resultsBuilder.setName(name);
    }

    func emit() throws -> String {
        try resultsBuilder.emit()
    }

    @discardableResult
    func withFields(_ fields: EditorialReview.Fields...) -> Self {
        resultsBuilder.withFields(fields)
        return self
    }

}