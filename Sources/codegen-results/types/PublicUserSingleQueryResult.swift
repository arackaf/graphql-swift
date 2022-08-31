import Foundation
import graphql_swift

struct PublicUserSingleQueryResult: Codable {
    var PublicUser: User?
 
    enum Fields: String { case empty }
}

class PublicUserSingleQueryResultBuilder: GraphqlResults {
    private let resultsBuilder = GraphqlResultsBuilder<PublicUserSingleQueryResult.Fields>()
    
    init() {}
    init(_ name: String) {
        resultsBuilder.setName(name);
    }

    func emit() throws -> String {
        try resultsBuilder.emit()
    }

    
    @discardableResult
    func withPublicUser(_ build: (UserBuilder) -> ()) -> Self {
        let res = UserBuilder("PublicUser")
        build(res)
        resultsBuilder.addResultSet(res)

        return self
    }
}