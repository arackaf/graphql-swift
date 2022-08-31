import Foundation
import graphql_swift

fileprivate func getQueryText(_ selection: String) -> String {
    return """
query getSubject ($_id: String, $publicUserId: String, $ver: String, $cache: Int) { 
  getSubject (
    _id: $_id
    publicUserId: $publicUserId
    ver: $ver
    cache: $cache
)

\(selection)

}
"""
}

struct GetSubjectFilters: Codable {
    var _id: String?
    var publicUserId: String?
    var ver: String?
    var cache: Int?
}

func getSubject(_ filters: GetSubjectFilters, buildSelection: (SubjectSingleQueryResultBuilder) -> ()) throws -> (GenericGraphQLRequest<GetSubjectFilters>, Codable.Type) {
    let selectionBuilder = SubjectSingleQueryResultBuilder()
    buildSelection(selectionBuilder)

    let selectionText = try selectionBuilder.emit()
    let query = getQueryText(selectionText);

    return (GenericGraphQLRequest<GetSubjectFilters>(query: query, variables: filters), SubjectSingleQueryResult.self)
}