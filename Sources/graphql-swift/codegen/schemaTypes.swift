import Foundation

extension Dictionary where Key == String {
    func val(_ key: String) -> [String: Any]? {
        return self[key] as? [String:Any]
    }
    
    func arr(_ key: String) -> [[String: Any]]? {
        return self[key] as? [[String:Any]]
    }
    
    func get<T>(_ key: String) -> T? {
        return self[key] as? T
    }
}

extension Array where Element == Dictionary<String, Any> {
    func produce<T>() -> [T]? where T:InitializableFromJSON {
        return self.map { T($0) }
    }
}

protocol InitializableFromJSON {
    init(_ json: [String: Any])
}

struct GraphqlFieldType: InitializableFromJSON {
    let name: String
    let type: String
    
    static func getType(_ json: [String: Any]) -> String {
        let kind: String? = json.get("kind")
        if kind == "LIST" {
            let nestedType = getType(json.val("ofType")!)
            return "Array<\(nestedType)>"
        } else {
            return json.get("name") ?? getType(json.val("ofType")!)
        }
    }
    
    init(_ json: [String: Any]){
        name = json.get("name")!
        let typeField = json.val("type")!
        type = Self.getType(typeField)
    }
}

struct GraphqlInputType: InitializableFromJSON {
    let name: String
    let fields: [GraphqlFieldType]
    
    init(_ json: [String: Any]){
        name = json.get("name")!
        fields = json.arr("inputFields")?.produce() ?? []
    }
}
