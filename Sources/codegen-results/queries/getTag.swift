import Foundation
import graphql_swift

fileprivate func getQueryText(_ selection: String) -> String {
    return """
query getTag ($_id: String, $publicUserId: String, $ver: String, $cache: Int) { 
  getTag (
    _id: $_id
    publicUserId: $publicUserId
    ver: $ver
    cache: $cache
)

\(selection)

}
"""
}

struct GetTagFilters: Codable {
    var _id: String?
    var publicUserId: String?
    var ver: String?
    var cache: Int?
}

func getTag(_ filters: GetTagFilters, buildSelection: (TagSingleQueryResultBuilder) -> ()) throws -> (GenericGraphQLRequest<GetTagFilters>, Codable.Type) {
    let selectionBuilder = TagSingleQueryResultBuilder()
    buildSelection(selectionBuilder)

    let selectionText = try selectionBuilder.emit()
    let query = getQueryText(selectionText);

    return (GenericGraphQLRequest<GetTagFilters>(query: query, variables: filters), TagSingleQueryResult.self)
}