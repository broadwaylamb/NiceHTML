public struct HTMLGlobalAttribute {

    fileprivate let key: String

    fileprivate let value: String?

    private init(_ key: String, value: String?) {
        self.key = key
        self.value = value
    }
}

public struct HTMLGlobalAttributes: HTMLTagAttributes {

    private let attributes: [String : String?]

    public init() {
        attributes = [:]
    }

    public init(_ attributes: HTMLGlobalAttribute...) {
        self.init(attributes)
    }

    public init<GlobalAttributes: Sequence>(_ attributes: GlobalAttributes)
        where GlobalAttributes.Element == HTMLGlobalAttribute
    {
        let keysAndValues = attributes.lazy.map { ($0.key, $0.value) }
        self.attributes = Dictionary(keysAndValues) { $1 }
    }

    public func render<Buffer: RangeReplaceableCollection>(into buffer: inout Buffer)
        where Buffer.Element == (key: String, value: String?)
    {
        buffer.append(contentsOf: attributes)
    }

    public var count: Int { attributes.count }
}

extension HTMLGlobalAttribute {

    public static func `class`<Class: HTMLCLass>(_ class: Class) -> Self {
        self.class(CollectionOfOne(`class`))
    }

    public static func `class`<Class: HTMLCLass>(_ classes: Class...) -> Self {
        self.class(classes)
    }

    public static func `class`<Classes: Sequence>(_ classes: Classes) -> Self
        where Classes.Element: HTMLCLass
    {
        .init("class", value: classes.lazy.map { $0.rawValue }.joined(separator: " "))
    }

    public static func id<ID: HTMLID>(_ id: ID) -> Self {
        .init("id", value: id.rawValue)
    }

    public static func lang(_ language: String) -> Self {
        .init("lang", value: language)
    }
}
