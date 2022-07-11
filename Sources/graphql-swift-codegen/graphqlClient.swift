import Foundation

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

func hasVal<T: Equatable & Codable>(_ inst: BookFilters, _ name: KeyPath<BookFilters, Optional<T>>) -> Bool {
    var s: String?
    
    if s == .none {
        
    }
    
    var xyz = inst[keyPath: name]

    var val: T? = inst[keyPath: name]
    return val != .none
    //return true;
}

struct GenericGraphQLRequest<T: Codable> : Codable {
    let query: String
    let variables: T
}

let bookQuery = """
query searchBooks(
      $authors_containsAny: [String]
)
{
  allBooks(authors_containsAny: $authors_containsAny) {
    Books{
      title
      isbn
      ean
    }
  }
}
"""

struct Book: Codable {
    let title: String
    let isbn: String
    let ean: String
    
    let junk: Int?
}

struct Books: Codable {
    var Books: [Book];
}

struct BookResults: Codable {
    var allBooks: Books;
}

struct GQLResponse<T: Codable>: Codable {
    var data: T
}

func decodeResponse<T: Decodable>(_ result: Data) throws -> T? {
    let decoder = JSONDecoder()
    
    return try decoder.decode(T.self, from: result)
}


open class GraphqlClient {
    let endpoint: URL
    
    public init(endpoint: URL) {
        self.endpoint = endpoint
    }
    
    public func run<T, D: Encodable>(requestBody: D, _ produceResult: (([String: Any]) -> T?)) async throws -> T? {
        guard let graphqlRequestPacket = try? JSONEncoder().encode(requestBody) else {
            print("Error: Trying to convert model to JSON data")
            return nil
        }

        var request = URLRequest(url: endpoint)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type") // the request is JSON
        request.setValue("application/json", forHTTPHeaderField: "Accept") // the response expected to be in JSON format
        request.httpBody = graphqlRequestPacket
        
        return try? await run(request: request, produceResult)
    }

    public func run<T>(request: URLRequest, _ produceResult: (([String: Any]) -> T?)) async throws -> T? {
        let jsonResult = try await jsonRequest(request);
        
        let graphqlData = jsonResult.object("data");
        guard let graphqlData = graphqlData else {
            return nil
        }
        return produceResult(graphqlData)
    }
    
    public func xyz() async {
        var bf = BookFilters()
        bf.authors_containsAny = ["Richard Dawkins", "Steven Pinker"];
        bf.timestamp = .some(nil)
        
        let requestBody = GenericGraphQLRequest(query: bookQuery, variables: bf);
        
        guard let graphqlRequestPacket = try? JSONEncoder().encode(requestBody) else {
            print("Error: Trying to convert model to JSON data")
            return
        }
        
        print("\n\nYO\n\n")
        print(String(decoding: graphqlRequestPacket, as: UTF8.self))

        print(hasVal(bf, \.timestamp))
        print(hasVal(bf, \.authors_containsAny))
        print(hasVal(bf, \.authors_in))
        
        
        var request = URLRequest(url: endpoint)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type") // the request is JSON
        request.setValue("application/json", forHTTPHeaderField: "Accept") // the response expected to be in JSON format
        request.httpBody = graphqlRequestPacket
        
        let result = try? await networkRequest(request)
        
        let decoder = JSONDecoder()
        if let result = result {
            
            if let bookResults: GQLResponse<BookResults> = try? decodeResponse(result) {
                print("YAYAY")
                
                print(bookResults)
            } else {
                print("NYOPE")
            }
        }
        
        /*
        if let result = result {
            print("\nBOOK QUERY\n\n")
            print(result)
            
            

            
            let foo = try? JSONSerialization.data(withJSONObject: result, options: .prettyPrinted)
            if let foo = foo {
                guard let stringy = String(data: foo, encoding: .utf8) else {
                    print("ERROR: failed to cast data as string")
                    return
                }
                
                print("stringified:\n")
                print(stringy)
                print("\n\n\n")
            }
        } else {
            print("\n\nERROR\n\n")
        }
        //return try? await run(request: request, produceResult)
        */
    }
}
