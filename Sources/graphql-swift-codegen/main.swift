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
    if var nestedArray = try? container.nestedUnkeyedContainer(forKey: key) {
        return process(fromArray: &nestedArray)
    }
    
    return nil
}

func process(fromSingleValue container: SingleValueDecodingContainer) -> Any? {
    if let result = try? container.decode(Int.self) { return result }
    if let result = try? container.decode(Double.self) { return result }
    if let result = try? container.decode(String.self) { return result }
    
    return nil
}

func process(fromContainer container: KeyedDecodingContainer<JSONCodingKeys>) -> [String: Any] {
    var result: [String: Any] = [:]
    
    for key in container.allKeys {
        result[key.stringValue] = containerValue(from: container, key: key)
    }
    
    return result
}

func process(fromArray container: inout UnkeyedDecodingContainer) -> [Any] {
    var result: [Any] = []

    while container.isAtEnd == false {
        if let value = try? container.decode(String.self) { result.append(value) }
        else if let value = try? container.decode(Int.self) { result.append(value) }
        else if let value = try? container.decode(Double.self) { result.append(value) }
        else if let value = try? container.nestedContainer(keyedBy: JSONCodingKeys.self) {
            result.append(process(fromContainer: value))
        }
        else if var value = try? container.nestedUnkeyedContainer() {
            result.append(process(fromArray: &value))
        }
    }
    
    return result
}

struct JSON: Decodable {
    var value: Any?
    
    init(from decoder: Decoder) throws {
        if let container = try? decoder.container(keyedBy: JSONCodingKeys.self) {
            self.value = process(fromContainer: container)
        } else if var array = try? decoder.unkeyedContainer() {
            self.value = process(fromArray: &array)
        } else if let value = try? decoder.singleValueContainer() {
            self.value = process(fromSingleValue: value)
        }
        print(self.value!)
    }
}

struct ThingWithJson: Decodable {
    let intVal: Int
    let stringVal: String
    let json: JSON
}

func runDecode(_ json: String) -> ThingWithJson? {
  let decoder = JSONDecoder()
  let data = json.data(using: .utf8)!

  return try? decoder.decode(ThingWithJson.self, from: data)
}

print("trying Int")
let resultInt = runDecode("""
{"intVal": 12, "stringVal": "Yo", "json": 99 }
""")

print(resultInt?.json.value as? Int ?? "nil")

print("\n\ntrying object")
let resultObject = runDecode("""
{"intVal": 12, "stringVal": "Yo", "json": { "num": 12, "str": "Hi", "dbl": 1.2, "arr": [1, 2, 3], "obj": { "int": 1, "o2": { "a": 1, "b": "b" } } } }
""")

if let map = resultObject?.json.value as? [String: Any] {
    print("got object")
    print(map["num"], map["dbl"])
    
    if let nestedMap = map["obj"] as? [String: Any] {
        print("Got nested object")
        print(nestedMap["int"])
        if let nestedMap2 = nestedMap["o2"] as? [String: Any] {
            print("Got nested object 2")
            print(nestedMap2["a"])
        }
    }
}

print("\n\ntrying array")
let resultArray = runDecode("""
{"intVal": 12, "stringVal": "Yo", "json": ["a", "b", ["c"], { "i": 1, "arr": ["a", 1, [9, 8, 7, { "z": "z" }]] }, 1, 2, 3] }
""")

if let arr = resultArray?.json.value as? [Any] {
    print("got array")
    print(arr[0])
    print(arr[1])
    print(arr[2])
    print(arr[3])
    
    if let nestedObj = arr[3] as? [String: Any] {
        print("nested object")
        print(nestedObj["i"])
        
        if let nestedArr2 = nestedObj["arr"] as? [Any] {
            print("nested arr2")
            print(nestedArr2[0])
        }
    }
}



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

