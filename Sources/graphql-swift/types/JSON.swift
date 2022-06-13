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
                self.value = decode(fromSingleValue: value)
            }
        }
    }
    
    public func encode(to encoder: Encoder) throws {
        if let map = self.value as? [String: Any] {
            var container = encoder.container(keyedBy: JSONCodingKeys.self)
            encodeValue(fromObjectContainer: &container, map: map)
        } else if let arr = self.value as? [Any] {
            var container = encoder.unkeyedContainer()
            encodeValue(fromArrayContainer: &container, arr: arr)
        } else {
            var container = encoder.singleValueContainer()
            encodeValue(fromSingleValueContainer: &container, value: self.value)
        }
    }
}
