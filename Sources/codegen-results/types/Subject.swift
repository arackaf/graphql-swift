import Foundation
import graphql_swift

struct Subject: Codable {
    var _id: String?
    var name: String?
    var path: String?
    var userId: String?
    var backgroundColor: String?
    var textColor: String?
    var timestamp: Float?
 
    enum Fields: String {
        case _id
        case name
        case path
        case userId
        case backgroundColor
        case textColor
        case timestamp
    }
}

class SubjectBuilder: GraphqlResults {
    private let resultsBuilder = GraphqlResultsBuilder<Subject.Fields>()
    
    init() {}
    init(_ name: String) {
        resultsBuilder.setName(name);
    }

    func emit() throws -> String {
        try resultsBuilder.emit()
    }

    @discardableResult
    func withFields(_ fields: Subject.Fields...) -> Self {
        resultsBuilder.withFields(fields)
        return self
    }

}