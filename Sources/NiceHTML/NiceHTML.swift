public protocol HTMLClass: RawRepresentable where RawValue == String {}

public protocol HTMLID: RawRepresentable where RawValue == String {}

public protocol HTMLTagAttributes {

  func render<Buffer: RangeReplaceableCollection>(into buffer: inout Buffer)
    where Buffer.Element == (key: String, value: String?)

  var count: Int { get }
}

extension HTMLTagAttributes {
  public var count: Int { 0 }
}

extension Never: HTMLTagAttributes {
  public func render<Buffer: RangeReplaceableCollection>(into: inout Buffer)
    where Buffer.Element == (key: String, value: String?)
  {
    switch self {}
  }
}
