import Foundation
import graphql_swift

struct UserSingleQueryResult: Codable {
    var User: User?
 
    enum Fields: String { case empty }
}

class UserSingleQueryResultBuilder: GraphqlResults {
    private let resultsBuilder = GraphqlResultsBuilder<UserSingleQueryResult.Fields>()
    
    init() {}
    init(_ name: String) {
        resultsBuilder.setName(name);
    }

    func emit() throws -> String {
        try resultsBuilder.emit()
    }

    
    @discardableResult
    func withUser(_ build: (UserBuilder) -> ()) -> Self {
        let res = UserBuilder("User")
        build(res)
        resultsBuilder.addResultSet(res)

        return self
    }
}