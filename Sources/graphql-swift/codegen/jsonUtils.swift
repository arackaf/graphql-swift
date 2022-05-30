import Foundation

public protocol InitializableFromJSON {
    init(_ json: [String: Any])
}

public extension Dictionary where Key == String {
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

public extension Array where Element == Dictionary<String, Any> {
    func produce<T>() -> [T]? where T: InitializableFromJSON {
        return self.map { T($0) }
    }
}
