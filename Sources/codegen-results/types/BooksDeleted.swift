import Foundation
import graphql_swift

struct BooksDeleted: Codable {
    var _id: String?
    var userId: String?
    var deletedTimestamp: Float?
 
    enum Fields: String {
        case _id
        case userId
        case deletedTimestamp
    }
}

class BooksDeletedBuilder: GraphqlResults {
    private let resultsBuilder = GraphqlResultsBuilder<BooksDeleted.Fields>()
    
    init() {}
    init(_ name: String) {
        resultsBuilder.setName(name);
    }

    func emit() throws -> String {
        try resultsBuilder.emit()
    }

    @discardableResult
    func withFields(_ fields: BooksDeleted.Fields...) -> Self {
        resultsBuilder.withFields(fields)
        return self
    }

}