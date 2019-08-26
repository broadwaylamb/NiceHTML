public protocol HTMLElement {

  associatedtype Attributes: HTMLTagAttributes

  static var name: String { get }

  var globalAttributes: HTMLGlobalAttributes { get }

  var attributes: Attributes { get }

  var children: HTMLNode { get }
}

extension HTMLElement {
  public func toNode() -> HTMLNode {
    var renderedAttrs = HTMLNode.RenderedAttributes()
    renderedAttrs.reserveCapacity(globalAttributes.count + attributes.count)
    attributes.render(into: &renderedAttrs)
    return .element(name: Self.name, attrs: renderedAttrs, child: children)
  }
}
