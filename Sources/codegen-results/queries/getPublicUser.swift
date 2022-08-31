import Foundation
import graphql_swift

fileprivate func getQueryText(_ selection: String) -> String {
    return """
query getPublicUser ($userId: String) { 
  getPublicUser (
    userId: $userId
)

\(selection)

}
"""
}

struct GetPublicUserFilters: Codable {
    var userId: String?
}

func getPublicUser(_ filters: GetPublicUserFilters, buildSelection: (PublicUserSingleQueryResultBuilder) -> ()) throws -> (GenericGraphQLRequest<GetPublicUserFilters>, Codable.Type) {
    let selectionBuilder = PublicUserSingleQueryResultBuilder()
    buildSelection(selectionBuilder)

    let selectionText = try selectionBuilder.emit()
    let query = getQueryText(selectionText);

    return (GenericGraphQLRequest<GetPublicUserFilters>(query: query, variables: filters), PublicUserSingleQueryResult?.self)
}