import Foundation
import graphql_swift

fileprivate func getQueryText(_ selection: String) -> String {
    return """
query getSubjectsDeleted ($_id: String) { 
  getSubjectsDeleted (
    _id: $_id
)

\(selection)

}
"""
}

struct GetSubjectsDeletedFilters: Codable {
    var _id: String?
}

func getSubjectsDeleted(_ filters: GetSubjectsDeletedFilters, buildSelection: (SubjectsDeletedSingleQueryResultBuilder) -> ()) throws -> (GenericGraphQLRequest<GetSubjectsDeletedFilters>, Codable.Type) {
    let selectionBuilder = SubjectsDeletedSingleQueryResultBuilder()
    buildSelection(selectionBuilder)

    let selectionText = try selectionBuilder.emit()
    let query = getQueryText(selectionText);

    return (GenericGraphQLRequest<GetSubjectsDeletedFilters>(query: query, variables: filters), SubjectsDeletedSingleQueryResult.self)
}