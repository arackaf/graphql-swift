import Foundation
import graphql_swift

struct LabelColorFilters: Codable {
    var OR: Array<LabelColorFilters?>?
}