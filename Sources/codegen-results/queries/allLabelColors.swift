import Foundation
import graphql_swift

fileprivate func getQueryText(_ selection: String) -> String {
    return """
query allLabelColors (
  $OR: [LabelColorFilters],
  $SORT: LabelColorSort,
  $SORTS: [LabelColorSort],
  $LIMIT: Int,
  $SKIP: Int,
  $PAGE: Int,
  $PAGE_SIZE: Int,
  $ver: String,
  $cache: Int
) { 
  allLabelColors (
    OR: $OR
    SORT: $SORT
    SORTS: $SORTS
    LIMIT: $LIMIT
    SKIP: $SKIP
    PAGE: $PAGE
    PAGE_SIZE: $PAGE_SIZE
    ver: $ver
    cache: $cache
)

\(selection)

}
"""
}

struct AllLabelColorsFilters: Codable {
    var OR: Array<LabelColorFilters?>?
    var SORT: LabelColorSort?
    var SORTS: Array<LabelColorSort?>?
    var LIMIT: Int?
    var SKIP: Int?
    var PAGE: Int?
    var PAGE_SIZE: Int?
    var ver: String?
    var cache: Int?
}

func allLabelColors(_ filters: AllLabelColorsFilters, buildSelection: (LabelColorQueryResultsBuilder) -> ()) throws -> (GenericGraphQLRequest<AllLabelColorsFilters>, Codable.Type) {
    let selectionBuilder = LabelColorQueryResultsBuilder()
    buildSelection(selectionBuilder)

    let selectionText = try selectionBuilder.emit()
    let query = getQueryText(selectionText);

    return (GenericGraphQLRequest<AllLabelColorsFilters>(query: query, variables: filters), LabelColorQueryResults.self)
}