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

public struct JSON: Codable {
    public var value: Any?
    
    public init(value: Any?) {
        self.value = value
    }
    public init(from decoder: Decoder) throws {
        if let container = try? decoder.container(keyedBy: JSONCodingKeys.self) {
            self.value = decode(fromObject: container)
        } else if var array = try? decoder.unkeyedContainer() {
            self.value = decode(fromArray: &array)
        } else if let value = try? decoder.singleValueContainer() {
            if value.decodeNil() {
                self.value = nil
            } else {
                if let result = try? value.decode(Int.self) { self.value = result }
                if let result = try? value.decode(Double.self) { self.value = result }
                if let result = try? value.decode(String.self) { self.value = result }
                if let result = try? value.decode(Bool.self) { self.value = result }
            }
        }
    }
    
    public func encode(to encoder: Encoder) throws {
        if let map = self.value as? [String: Any] {
            var container = encoder.container(keyedBy: JSONCodingKeys.self)
            try encodeValue(fromObjectContainer: &container, map: map)
        } else if let arr = self.value as? [Any] {
            var container = encoder.unkeyedContainer()
            try encodeValue(fromArrayContainer: &container, arr: arr)
        } else {
            var container = encoder.singleValueContainer()
            
            if let value = self.value as? String {
                try! container.encode(value)
            } else if let value = self.value as? Int {
                try! container.encode(value)
            } else if let value = self.value as? Double {
                try! container.encode(value)
            } else if let value = self.value as? Bool {
                try! container.encode(value)
            } else {
                try! container.encodeNil()
            }
        }
    }
}
