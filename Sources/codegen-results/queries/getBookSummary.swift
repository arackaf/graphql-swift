import Foundation
import graphql_swift

fileprivate func getQueryText(_ selection: String) -> String {
    return """
query getBookSummary ($_id: String) { 
  getBookSummary (
    _id: $_id
)

\(selection)

}
"""
}

struct GetBookSummaryFilters: Codable {
    var _id: String?
}

func getBookSummary(_ filters: GetBookSummaryFilters, buildSelection: (BookSummarySingleQueryResultBuilder) -> ()) throws -> (GenericGraphQLRequest<GetBookSummaryFilters>, Codable.Type) {
    let selectionBuilder = BookSummarySingleQueryResultBuilder()
    buildSelection(selectionBuilder)

    let selectionText = try selectionBuilder.emit()
    let query = getQueryText(selectionText);

    return (GenericGraphQLRequest<GetBookSummaryFilters>(query: query, variables: filters), BookSummarySingleQueryResult.self)
}