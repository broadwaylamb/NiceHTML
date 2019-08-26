import NiceHTMLStream

public enum HTMLNode {

  public typealias RenderedAttributes = [(key: String, value: String?)]

  case comment(String)

  indirect case element(name: String,
                        attrs: [(key: String, value: String?)],
                        child: HTMLNode)

  case voidElement(name: String, attrs: [(key: String, value: String?)])

  indirect case fragment([HTMLNode])

  case raw(String)

  case text(String)
}

extension HTMLNode  {

  public enum RenderingStyle {
    case compact
    case prettyPrintedWithTabs(intialIndentation: Int)
    case prettyPrintedWithSpaces(intialIndentation: Int, indent: Int)
  }

  public func render<OutputStream: HTMLOutputStream>(
    renderingStyle: RenderingStyle
  ) -> (OutputStream) throws -> Void {
    { stream in
      switch renderingStyle {
      case .compact:
        try self.renderCompact(into: stream)
      case let .prettyPrintedWithTabs(intialIndentation):
        try self.renderPrettyPrinted(into: stream,
                                     character: OutputStream.tab,
                                     currentIndentation: intialIndentation,
                                     increment: 1)
      case let .prettyPrintedWithSpaces(intialIndentation, indent):
        try self.renderPrettyPrinted(into: stream,
                                     character: OutputStream.space,
                                     currentIndentation: intialIndentation,
                                     increment: indent)
      }
    }
  }

  private func renderCompact<OutputStream: HTMLOutputStream>(
    into stream: OutputStream
  ) throws {
    switch self {
    case let .comment(c):
      try stream <<< NiceHTMLStream.comment(c)
    case let .element(name, attrs, child):
      try stream <<< tag(name, attributes: attrs)
      try child.renderCompact(into: stream)
      try stream <<< closeTag(name)
    case let .voidElement(name, attrs):
      try stream <<< tag(name, attributes: attrs)
    case let .fragment(children):
      for child in children {
        try child.renderCompact(into: stream)
      }
    case let .raw(html):
      try stream <<< html
    case let .text(str):
      try stream <<< NiceHTMLStream.text(str)
    }
  }

  private func renderPrettyPrinted<OutputStream: HTMLOutputStream>(
    into stream: OutputStream,
    character: OutputStream.Element,
    currentIndentation: Int,
    increment: Int
  ) throws {
    let indent: (OutputStream) throws -> Void =
      repeatCharacter(character, count: currentIndentation)

    switch self {
    case let .comment(c):
      try stream <<< indent
                 <<< NiceHTMLStream.comment(c)
                 <<< newline
    case let .element(name, attrs, child):
      try stream <<< indent
                 <<< tag(name, attributes: attrs)
                 <<< newline
      try child.renderPrettyPrinted(into: stream,
                                    character: character,
                                    currentIndentation: currentIndentation + increment,
                                    increment: increment)
      try stream <<< indent
                 <<< closeTag(name)
                 <<< newline
    case let .voidElement(name, attrs):
      try stream <<< indent
                 <<< tag(name, attributes: attrs)
                 <<< newline
    case let .fragment(children):
      for child in children {
        try child.renderPrettyPrinted(into: stream,
                                      character: character,
                                      currentIndentation: currentIndentation,
                                      increment: increment)
      }
    case let .raw(html):
      for line in html.split(separator: "\n") {
        try stream <<< indent <<< line <<< newline
      }
    case let .text(str):
      try stream <<< indent <<< NiceHTMLStream.text(str) <<< newline
    }
  }
}

extension HTMLNode: CustomStringConvertible {
  public var description: String {
    let stream = HTMLStringStream()
    try! stream <<< self
      .render(renderingStyle: .prettyPrintedWithSpaces(intialIndentation: 0,
                                                       indent: 2))
    return stream.result
  }
}

public struct HTMLDocument {
  public let doctype: String?
  public let node: HTMLNode

  public init(doctype: String?, node: HTMLNode) {
    self.doctype = doctype
    self.node = node
  }

  public func render<OutputStream: HTMLOutputStream>(
    renderingStyle: HTMLNode.RenderingStyle
  ) -> (OutputStream) throws -> Void {
    { stream in
      try self.renderDoctype(into: stream, renderingStyle: renderingStyle)
      try stream <<< self.node.render(renderingStyle: renderingStyle)
    }
  }

  private func renderDoctype<OutputStream: HTMLOutputStream>(
    into stream: OutputStream,
    renderingStyle: HTMLNode.RenderingStyle
  ) throws {
    guard let doctype = doctype else { return }
    switch renderingStyle {
    case .compact:
      try stream <<< NiceHTMLStream.doctype(doctype)
    case let .prettyPrintedWithTabs(intialIndentation):
      try stream <<< repeatCharacter(OutputStream.tab, count: intialIndentation)
                 <<< NiceHTMLStream.doctype(doctype)
                 <<< newline
    case let .prettyPrintedWithSpaces(intialIndentation, indent):
      try stream <<< repeatCharacter(OutputStream.space,
                                     count: intialIndentation * indent)
                 <<< NiceHTMLStream.doctype(doctype)
                 <<< newline
    }
  }
}

extension HTMLDocument: CustomStringConvertible {
  public var description: String {
    let stream = HTMLStringStream()
    try! stream <<< self
      .render(renderingStyle: .prettyPrintedWithSpaces(intialIndentation: 0,
                                                       indent: 2))
    return stream.result
  }
}
