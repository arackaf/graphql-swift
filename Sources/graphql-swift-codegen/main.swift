import Foundation
import graphql_swift

protocol Lookup {
    static var lookup: [PartialKeyPath<Self>:String] { get }
}

struct NestedType: Lookup {
    let x: String
    let y: Float
    
    static var lookup: [PartialKeyPath<NestedType>:String] = [\.x: "x", \.y: "y"]
}

//let x: NestedType.F = .a

//func withNestedType(@GraphQLResultBuilder req: () -> String) -> String {
//    return req()
//}

struct SomeType: Lookup {
    let a: String
    let b: Int
    let f: Float
    
    enum fields: String {
        case a = "a"
        case b = "b"
    }
    static var lookup: [PartialKeyPath<SomeType>:String] = [\.a: "a", \.b: "b", \.f: "f"]
}

//func agf<T: String | Int>(_ val: T) {
//
//}

struct FromKP<T> {
    init(_ kp: PartialKeyPath<T>) {
        
    }
    
    init(_ kp: KeyPath<T, String>) {
        
    }
}

@resultBuilder
struct GraphQLResultBuilder<T: Lookup> {
//    static func buildBlock(_ kp: KeyPath<T, String>) -> String {
//        return T.lookup[kp]!
//    }
//    static func buildBlock(_ kp: KeyPath<T, Int>) -> String {
//        return T.lookup[kp]!
//    }
    
    static func buildBlock(_ kps: FromKP<T>...) -> String {
        return ""
        //return kps.map({ T.lookup[$0] ?? "" }).joined(separator: ", ")
    }
}

func buildSomeTypeRequest(@GraphQLResultBuilder<SomeType> req: () -> String) -> String {
    return req()
}

//let reqString = buildSomeTypeRequest {
//    \SomeType.a
//    \SomeType.b
//    //\SomeType.f
//}

let pkp: PartialKeyPath<SomeType> = \.a

//let reqString = buildSomeTypeRequest {
//    \SomeType.a
//    \SomeType.b
//
//    withNestedType {
//        \NestedType.x
//    }
//}

//print("AAA", reqString)

//print(build())


for argument in CommandLine.arguments {
    print(argument)
}

let graphqlUrl = "https://mylibrary.onrender.com/graphql"
let junk: Dictionary<String, Any> = [:]

struct ThingWithJson: Codable {
    let intVal: Int
    let stringVal: String
    let json: JSON
}

func runDecode(_ json: String) -> ThingWithJson? {
  let decoder = JSONDecoder()
  let data = json.data(using: .utf8)!

  return try? decoder.decode(ThingWithJson.self, from: data)
}


let testing: Optional<Any> = Optional<Any>(nil) as Any

if let testVal = testing {
    print("TESTING HAS VALUE", testVal)
} else {
    print("TESTING NOOOOO VALUE")
}

let json = """
    { "a": 12, "b": "Hello", "null": null, "arr": [1, 2, 3], "obj": { "nestedInt": 12, "nestedString": "str" } }
""".data(using: .utf8)!

if let jsonObject = try? JSONSerialization.jsonObject(with: json) as? [String: Any] {
    print(jsonObject, "\n")
    
    if let hasValue = jsonObject["null"] {
        print("HAS VALUE", hasValue)
    }
    
    print("typeof null", type(of: jsonObject["null"]))
    let nullInst: Optional<Any> = jsonObject["null"]
    if let val = nullInst {
        print("TYPE VAL", type(of: val))
        print("VAL", val)
    } else {
        print("VAL is nil")
    }
    
    if let intArray = jsonObject["arr"] as? [Int] {
        print(intArray[0])
    }
}



print("\n\ntrying Int")
let resultInt = runDecode("""
{"intVal": 12, "stringVal": "Yo", "json": 99 }
""")

print(resultInt?.json.value as? Int ?? "nil")

print("\n\ntrying object")
let resultObject = runDecode("""
{"intVal": 12, "stringVal": "Yo", "json": { "num": 12, "null": null, "nullArr": [1, null, { "a": "a", "null": null }], "str": "Hi", "dbl": 1.2, "arr": [1, 2, 3], "obj": { "int": 1, "o2": { "a": 88, "b": "b" } } } }
""")

print("\n", resultObject, "\n")

if let map = resultObject?.json.value as? [String: Any] {
    print("got object")
    print(map["num"]!, map["dbl"]!)
    print("null", map["null"] ?? "<null>")
    print("nullArr", map["nullArr"]!)

    let nullarr = map["nullArr"] as! [Any]
    if let secondVal = nullarr[1] as Any? {
        print("SECOND VAL", secondVal)
    }
    

    if let nullMap = nullarr[2] as? [String: Any] {
        print("null map", nullMap)
        
        print("Keys")
        for k in nullMap.keys {
            print(k, nullMap[k])
        }
        print("End keys")
    }
    
    if let nestedMap = map["obj"] as? [String: Any] {
        print("Got nested object")
        print(nestedMap["int"]!)
        if let nestedMap2 = nestedMap["o2"] as? [String: Any] {
            print("Got nested object 2")
            print(nestedMap2["a"]!)
        }
    }
}

print("\n\ntrying array")
let resultArray = runDecode("""
{"intVal": 12, "stringVal": "Yo", "json": ["a", "b", ["c"], { "i": 1, "arr": ["a", 1, [9, 8, 7, { "z": "z" }]] }, 1, 2, 3] }
""")

print("\n", resultArray, "\n")

if let arr = resultArray?.json.value as? [Any] {
    print("got array")
    print(arr[0])
    print(arr[1])
    print(arr[2])
    print(arr[3])
    
    if let nestedObj = arr[3] as? [String: Any] {
        print("nested object")
        print(nestedObj["i"]!)
        
        if let nestedArr2 = nestedObj["arr"] as? [Any] {
            print("nested arr2")
            print(nestedArr2[0])
        }
    }
}

print("\n\ntrying null")
let resultNull = runDecode("""
{"intVal": 12, "stringVal": "Yo", "json": null }
""")

print(resultNull, "\n\n")

if let valResultNull = resultNull?.json.value {
    print("HAS RESULT NULL", valResultNull)
} else {
    print("NO RESULT NULL")
}

func runEncode(_ movie: ThingWithJson) {
    let encoder = JSONEncoder()
    if let result = try? encoder.encode(movie) {
        let json = String(data: result, encoding: .utf8)!
        print(json, "\n")
    }
}

runEncode(ThingWithJson(intVal: 1, stringVal: "String - yo", json: JSON(value: "Yo")))

runEncode(ThingWithJson(intVal: 2, stringVal: "Object / Map", json: JSON(value: ["a": 12, "b": "Hi"])))

runEncode(ThingWithJson(intVal: 3, stringVal: "null", json: JSON(value: nil)))

runEncode(ThingWithJson(intVal: 4, stringVal: "nested object", json: JSON(value: ["a": 12, "o": ["b": 2, "c": "hi"]])))

runEncode(ThingWithJson(intVal: 5, stringVal: "array", json: JSON(value: [1, [2, nil, [ "str": "string", "nil": nil, "arr": ["a", ["b"]] ]], 3])))


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

myGroup.wait()

