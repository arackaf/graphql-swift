import Foundation
import graphql_swift

struct PublicUser: Codable {
    var email: String?
    var isPublic: Bool?
    var publicName: String?
    var publicBooksHeader: String?
 
    enum Fields: String {
        case email
        case isPublic
        case publicName
        case publicBooksHeader
    }
}

class PublicUserBuilder: GraphqlResults {
    private let resultsBuilder = GraphqlResultsBuilder<PublicUser.Fields>()
    
    init() {}
    init(_ name: String) {
        resultsBuilder.setName(name);
    }

    func emit() throws -> String {
        try resultsBuilder.emit()
    }

    @discardableResult
    func withFields(_ fields: PublicUser.Fields...) -> Self {
        resultsBuilder.withFields(fields)
        return self
    }

}