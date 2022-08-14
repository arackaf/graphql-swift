import Foundation



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
