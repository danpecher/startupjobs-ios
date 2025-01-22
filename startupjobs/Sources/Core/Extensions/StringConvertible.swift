protocol StringConvertible {
    var stringValue: String { get }
}

extension String: StringConvertible {
    var stringValue: String { self }
}
