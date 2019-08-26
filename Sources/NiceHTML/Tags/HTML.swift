public struct HTML: HTMLElement {

  public struct Attributes: HTMLTagAttributes {
    public let xmlns: String?

    public func render<Buffer: RangeReplaceableCollection>(into buffer: inout Buffer)
      where Buffer.Element == (key: String, value: String?)
    {
      if let xmlns = xmlns {
        buffer.append((key: "xmlns", value: xmlns))
      }
    }

    public var count: Int { xmlns == nil ? 0 : 1 }
  }

  public static let name = "html"

  public let globalAttributes: HTMLGlobalAttributes

  public let attributes: Attributes

  public let children: HTMLNode

#if swift(>=5.1) // Function builders

  public init(_ globalAttributes: HTMLGlobalAttribute...,
              xmlns: String? = nil,
              @HTMLBuilder content: () -> HTMLNode) {
    self.globalAttributes = HTMLGlobalAttributes(globalAttributes)
    self.attributes = Attributes(xmlns: xmlns)
    self.children = content()
  }
#endif // swift(>=5.1)
}
