import Foundation
import graphql_swift

fileprivate func getQueryText(_ selection: String) -> String {
    return """
query getUser  { 
  getUser (
    
)

\(selection)

}
"""
}

struct GetUserFilters: Codable {
    
}

func getUser(_ filters: GetUserFilters, buildSelection: (UserSingleQueryResultBuilder) -> ()) throws -> (GenericGraphQLRequest<GetUserFilters>, Codable.Type) {
    let selectionBuilder = UserSingleQueryResultBuilder()
    buildSelection(selectionBuilder)

    let selectionText = try selectionBuilder.emit()
    let query = getQueryText(selectionText);

    return (GenericGraphQLRequest<GetUserFilters>(query: query, variables: filters), UserSingleQueryResult?.self)
}