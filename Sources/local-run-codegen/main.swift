import Foundation
import graphql_swift


let graphqlUrl = "https://mylibrary.onrender.com/graphql"

func run() async {
    do {
        print("calling networkRequest()")
        
        let client = GraphqlClient(endpoint: URL(string: graphqlUrl)!)
        
        await client.xyz()
        
        let schemaGenerator = SchemaTypeGenerator(client: client)
        let inputTypesResponse = try await schemaGenerator.readInputTypes()
        let typesResponse = try await schemaGenerator.readTypes()
        let queriesResponse = try await schemaGenerator.readQueries()
        let rootOutputUrl = URL(fileURLWithPath: "/Users/arackis/Documents/git/swift-codegen")

        let inputTypeGenerator = TypeGenerator();

        if let inputTypesResponse = inputTypesResponse {
            for type in inputTypesResponse {
                inputTypeGenerator.writeInputType(url: rootOutputUrl.appendingPathComponent("input-types"), inputType: type)
            }
        }
        
        if let typesResponse = typesResponse {
            for type in typesResponse {
                inputTypeGenerator.writeType(url: rootOutputUrl.appendingPathComponent("types"), type: type)
            }
        }
        
        if let queriesResponse = queriesResponse {
            inputTypeGenerator.writeQueries(url: rootOutputUrl.appendingPathComponent("queries"), queries: queriesResponse)
        }
    } catch {
        print("caught")
    }
}
let myGroup = DispatchGroup()
myGroup.enter()

Task {
    await run()
    
    myGroup.leave() //// When your task completes
}

//myGroup.wait()


struct BookFilters : Codable {
    var isbn_contains: String?
    var isbn_startsWith: String?
    var isbn_endsWith: String?
    var isbn_regex: String?
    var isbn: String?
    var isbn_ne: String?
    var isbn_in: Array<String?>?
    var isbn_nin: Array<String?>?
    var title_contains: String?
    var title_startsWith: String?
    var title_endsWith: String?
    var title_regex: String?
    var title: String?
    var title_ne: String?
    var title_in: Array<String?>?
    var title_nin: Array<String?>?
    var userId_contains: String?
    var userId_startsWith: String?
    var userId_endsWith: String?
    var userId_regex: String?
    var userId: String?
    var userId_ne: String?
    var userId_in: Array<String?>?
    var userId_nin: Array<String?>?
    var publisher_contains: String?
    var publisher_startsWith: String?
    var publisher_endsWith: String?
    var publisher_regex: String?
    var publisher: String?
    var publisher_ne: String?
    var publisher_in: Array<String?>?
    var publisher_nin: Array<String?>?
    var pages_lt: Int?
    var pages_lte: Int?
    var pages_gt: Int?
    var pages_gte: Int?
    var pages: Int?
    var pages_ne: Int?
    var pages_in: Array<Int?>?
    var pages_nin: Array<Int?>?
    var authors_count: Int?
    var authors_textContains: String?
    var authors_startsWith: String?
    var authors_endsWith: String?
    var authors_regex: String?
    var authors: Array<String?>?
    var authors_in: Array<Array<String?>?>?
    var authors_nin: Array<Array<String?>?>?
    var authors_contains: String?
    var authors_containsAny: Array<String?>?
    var authors_containsAll: Array<String?>?
    var authors_ne: Array<String?>?
    var subjects_count: Int?
    var subjects_textContains: String?
    var subjects_startsWith: String?
    var subjects_endsWith: String?
    var subjects_regex: String?
    var subjects: Array<String?>?
    var subjects_in: Array<Array<String?>?>?
    var subjects_nin: Array<Array<String?>?>?
    var subjects_contains: String?
    var subjects_containsAny: Array<String?>?
    var subjects_containsAll: Array<String?>?
    var subjects_ne: Array<String?>?
    var tags_count: Int?
    var tags_textContains: String?
    var tags_startsWith: String?
    var tags_endsWith: String?
    var tags_regex: String?
    var tags: Array<String?>?
    var tags_in: Array<Array<String?>?>?
    var tags_nin: Array<Array<String?>?>?
    var tags_contains: String?
    var tags_containsAny: Array<String?>?
    var tags_containsAll: Array<String?>?
    var tags_ne: Array<String?>?
    var isRead: Bool?
    var isRead_ne: Bool?
    var isRead_in: Array<Bool?>?
    var isRead_nin: Array<Bool?>?
    var dateAdded_contains: String?
    var dateAdded_startsWith: String?
    var dateAdded_endsWith: String?
    var dateAdded_regex: String?
    var dateAdded: String?
    var dateAdded_ne: String?
    var dateAdded_in: Array<String?>?
    var dateAdded_nin: Array<String?>?
    var timestamp_lt: Float?
    var timestamp_lte: Float?
    var timestamp_gt: Float?
    var timestamp_gte: Float?
    var timestamp: Float??
    var timestamp_ne: Float?
    var timestamp_in: Array<Float?>?
    var timestamp_nin: Array<Float?>?
    var OR: Array<BookFilters?>?
}

var filters = BookFilters()

filters.pages_in = [1, 2, 3]

let encodedData = try JSONEncoder().encode(filters)
let jsonString = String(data: encodedData, encoding: .utf8)

print("Value:")
print("Value" + jsonString!)
