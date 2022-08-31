import Foundation
import graphql_swift

struct StringArrayUpdate: Codable {
    var index: Int
    var value: String
}