import Foundation

public struct JSONCodingKeys: CodingKey {
    public var stringValue: String
    
    public init(stringValue: String) {
        self.stringValue = stringValue
    }
    
    public var intValue: Int?
    
    public init?(intValue: Int) {
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

public struct JSON: Decodable {
    public var value: Any?
    
    public init(from decoder: Decoder) throws {
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
