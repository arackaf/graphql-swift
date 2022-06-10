import Foundation
import graphql_swift

for argument in CommandLine.arguments {
    print(argument)
}

let graphqlUrl = "https://mylibrary.onrender.com/graphql"

struct JSONCodingKeys: CodingKey {
    var stringValue: String
    
    init(stringValue: String) {
        self.stringValue = stringValue
    }
    
    var intValue: Int?
    
    init?(intValue: Int) {
        self.init(stringValue: "\(intValue)")
        self.intValue = intValue
    }
}

func containerValue(from container: KeyedDecodingContainer<JSONCodingKeys>, key: JSONCodingKeys) -> Any? {
    if let result = try? container.decode(Int.self, forKey: key) { return result }
    if let result = try? container.decode(Double.self, forKey: key) { return result }
    if let result = try? container.decode(String.self, forKey: key) { return result }
    if let nestedContainer = try? container.nestedContainer(keyedBy: JSONCodingKeys.self, forKey: key) {
        return process(fromContainer: nestedContainer)
    }
    
    return nil
}

func process(fromContainer container: KeyedDecodingContainer<JSONCodingKeys>) -> [String: Any] {
    var result: [String: Any] = [:]
    
    for key in container.allKeys {
        result[key.stringValue] = containerValue(from: container, key: key)
    }
    
    return result
}

func process(fromSingleValue container: SingleValueDecodingContainer) -> Any? {
    if let result = try? container.decode(Int.self) { return result }
    if let result = try? container.decode(Double.self) { return result }
    if let result = try? container.decode(String.self) { return result }
    
    return nil
}

struct JSON: Decodable {
    var value: Any?
    
    init(from decoder: Decoder) throws {
        if let junk = try? decoder.container(keyedBy: JSONCodingKeys.self) {
            for k in junk.allKeys {
                self.value = process(fromContainer: junk)
            }
        } else if let junk = try? decoder.singleValueContainer() {
            self.value = process(fromSingleValue: junk)
        } else {
            print("NOTHING")
        }
        
        print(self.value)
    }
}

struct Foo: Decodable {
    let a: Int
    let b: String
    let x: JSON
}

func runDecode(_ json: String) {
  let decoder = JSONDecoder()
  let data = json.data(using: .utf8)!

  _ = try? decoder.decode(Foo.self, from: data)
}

print("trying 99")
runDecode("""
{"a": 12, "b": "Yo", "x": 99 }
""")

print("trying object")
runDecode("""
{"a": 12, "b": "Yo", "x": { "num": 12, "str": "Hi", "dbl": 1.2, "obj": { "int": 1, "o2": { "a": 1, "b": "b" } } } }
""")

func run() async {
    do {
        print("calling networkRequest()")
        
        let client = GraphqlClient(endpoint: URL(string: graphqlUrl)!)
        let schemaGenerator = SchemaTypeGenerator(client: client)
        let inputTypesResponse = try await schemaGenerator.readInputTypes()
        let typesResponse = try await schemaGenerator.readTypes()
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
    } catch {
        print("caught")
    }
}

let myGroup = DispatchGroup()
myGroup.enter()

Task {
    //await run()
    
    myGroup.leave() //// When your task completes
}

myGroup.wait()

