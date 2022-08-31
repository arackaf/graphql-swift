import Foundation
import graphql_swift

fileprivate func getQueryText(_ selection: String) -> String {
    return """
query getTagsDeleted ($_id: String) { 
  getTagsDeleted (
    _id: $_id
)

\(selection)

}
"""
}

struct GetTagsDeletedFilters: Codable {
    var _id: String?
}

func getTagsDeleted(_ filters: GetTagsDeletedFilters, buildSelection: (TagsDeletedSingleQueryResultBuilder) -> ()) throws -> (GenericGraphQLRequest<GetTagsDeletedFilters>, Codable.Type) {
    let selectionBuilder = TagsDeletedSingleQueryResultBuilder()
    buildSelection(selectionBuilder)

    let selectionText = try selectionBuilder.emit()
    let query = getQueryText(selectionText);

    return (GenericGraphQLRequest<GetTagsDeletedFilters>(query: query, variables: filters), TagsDeletedSingleQueryResult.self)
}