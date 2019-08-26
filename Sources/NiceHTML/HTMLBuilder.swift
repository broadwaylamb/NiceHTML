#if swift(>=5.1)

@_functionBuilder
public struct HTMLBuilder {

//  @_alwaysEmitIntoClient
//  public static func buildBlock(_ text: String...) -> HTMLNode {
//    .text(text.joined(separator: " "))
//  }

  @_alwaysEmitIntoClient
  public static func buildBlock(_ text: String) -> HTMLNode {
    .text(text)
  }

//  @_alwaysEmitIntoClient
//  public static func buildBlock<Content: HTMLElement>(_ children: Content) -> HTMLNode {
//    children.toNode()
//  }
}

#endif // swift(>=5.1)
