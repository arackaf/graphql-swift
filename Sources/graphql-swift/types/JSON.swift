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

func decode(fromSingleValue container: SingleValueDecodingContainer) -> Any? {
    if let result = try? container.decode(Int.self) { return result }
    if let result = try? container.decode(Double.self) { return result }
    if let result = try? container.decode(String.self) { return result }
    if let result = try? container.decode(Bool.self) { return result }
    
    return nil
}

func decode(fromContainer container: KeyedDecodingContainer<JSONCodingKeys>) -> [String: Any?] {
    var result: [String: Any?] = [:]

    
    for key in container.allKeys {
        if let val = try? container.decode(Int.self, forKey: key) { result[key.stringValue] = val }
        else if let val = try? container.decode(Double.self, forKey: key) { result[key.stringValue] = val }
        else if let val = try? container.decode(String.self, forKey: key) { result[key.stringValue] = val }
        else if let val = try? container.decode(Bool.self, forKey: key) { result[key.stringValue] = val }
        else if let nestedContainer = try? container.nestedContainer(keyedBy: JSONCodingKeys.self, forKey: key) {
            result[key.stringValue] = decode(fromContainer: nestedContainer)
        }
        else if var nestedArray = try? container.nestedUnkeyedContainer(forKey: key) {
            result[key.stringValue] = decode(fromArray: &nestedArray)
        } else if (try? container.decodeNil(forKey: key)) == true  {
            result[key.stringValue] = nil as Any?
        }
    }
    
    return result
}

func decode(fromArray container: inout UnkeyedDecodingContainer) -> [Any?] {
    var result: [Any?] = []

    while container.isAtEnd == false {
        if let value = try? container.decode(String.self) { result.append(value) }
        else if let value = try? container.decode(Int.self) { result.append(value) }
        else if let value = try? container.decode(Double.self) { result.append(value) }
        else if let value = try? container.decode(Bool.self) { result.append(value) }
        else if let nestedContainer = try? container.nestedContainer(keyedBy: JSONCodingKeys.self) {
            result.append(decode(fromContainer: nestedContainer))
        }
        else if var nestedArray = try? container.nestedUnkeyedContainer() {
            result.append(decode(fromArray: &nestedArray))
        } else if (try? container.decodeNil()) == true {
            result.append(nil)
        }
    }
    
    return result
}

func encodeValue(fromSingleValueContainer container: inout SingleValueEncodingContainer, value: Any?) {
    if let value = value as? String {
        try? container.encode(value)
    } else if let value = value as? Int {
        try? container.encode(value)
    } else if let value = value as? Double {
        try? container.encode(value)
    } else if let value = value as? Bool {
        try? container.encode(value)
    } else {
        try? container.encodeNil()
    }
}

func encodeValue(fromObjectContainer container: inout KeyedEncodingContainer<JSONCodingKeys>, map: [String:Any?]) {
    for k in map.keys {
        let value = map[k]
        let encodingKey = JSONCodingKeys(stringValue: k)
        
        if let value = value as? String {
            try? container.encode(value, forKey: encodingKey)
        } else if let value = value as? Int {
            try? container.encode(value, forKey: encodingKey)
        } else if let value = value as? Double {
            try? container.encode(value, forKey: encodingKey)
        } else if let value = value as? Bool {
            try? container.encode(value, forKey: encodingKey)
        } else if let value = value as? [String: Any?] {
            var keyedContainer = container.nestedContainer(keyedBy: JSONCodingKeys.self, forKey: encodingKey)
            encodeValue(fromObjectContainer: &keyedContainer, map: value)
        } else if let value = value as? [Any?] {
            var unkeyedContainer = container.nestedUnkeyedContainer(forKey: encodingKey)
            encodeValue(fromArrayContainer: &unkeyedContainer, arr: value)
        } else {
            try? container.encodeNil(forKey: encodingKey)
        }
        
    }
}

func encodeValue(fromArrayContainer container: inout UnkeyedEncodingContainer, arr: [Any?]) {
    for value in arr {
        if let value = value as? String {
            try? container.encode(value)
        } else if let value = value as? Int {
            try? container.encode(value)
        } else if let value = value as? Double {
            try? container.encode(value)
        } else if let value = value as? Bool {
            try? container.encode(value)
        } else if let value = value as? [String: Any?] {
            var keyedContainer = container.nestedContainer(keyedBy: JSONCodingKeys.self)
            encodeValue(fromObjectContainer: &keyedContainer, map: value)
        } else if let value = value as? [Any?] {
            var unkeyedContainer = container.nestedUnkeyedContainer()
            encodeValue(fromArrayContainer: &unkeyedContainer, arr: value)
        } else {
            try? container.encodeNil()
        }
        
    }
}

public struct JSON: Codable {
    public var value: Any?
    
    public init(value: Any?) {
        self.value = value
    }
    public init(from decoder: Decoder) throws {
        if let container = try? decoder.container(keyedBy: JSONCodingKeys.self) {
            self.value = decode(fromContainer: container)
        } else if var array = try? decoder.unkeyedContainer() {
            self.value = decode(fromArray: &array)
        } else if let value = try? decoder.singleValueContainer() {
            self.value = decode(fromSingleValue: value)
        }
    }
    
    public func encode(to encoder: Encoder) throws {
        if let map = self.value as? [String: Any?] {
            var container = encoder.container(keyedBy: JSONCodingKeys.self)
            encodeValue(fromObjectContainer: &container, map: map)
        } else if let arr = self.value as? [Any?] {
            var container = encoder.unkeyedContainer()
            encodeValue(fromArrayContainer: &container, arr: arr)
        } else {
            var container = encoder.singleValueContainer()
            encodeValue(fromSingleValueContainer: &container, value: self.value)
        }
    }
}
