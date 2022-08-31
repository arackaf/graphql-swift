import Foundation
import graphql_swift

struct User: Codable {
    var email: String?
    var userId: String?
    var isPublic: Bool?
    var publicName: String?
    var publicBooksHeader: String?
 
    enum Fields: String {
        case email
        case userId
        case isPublic
        case publicName
        case publicBooksHeader
    }
}

class UserBuilder: GraphqlResults {
    private let resultsBuilder = GraphqlResultsBuilder<User.Fields>()
    
    init() {}
    init(_ name: String) {
        resultsBuilder.setName(name);
    }

    func emit() throws -> String {
        try resultsBuilder.emit()
    }

    @discardableResult
    func withFields(_ fields: User.Fields...) -> Self {
        resultsBuilder.withFields(fields)
        return self
    }

}