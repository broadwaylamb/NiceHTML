public final class HTMLByteStream: HTMLOutputStream {

  @usableFromInline
  internal var _result: [UInt8]

  @inlinable
  public var result: [UInt8] { _result }

  @inlinable
  public init() {
    _result = []
  }

  public typealias Element = UInt8

  public typealias Slice = ArraySlice<UInt8>

  public static let space: UInt8 = 0x20

  public static let newline: UInt8 = 0x0A

  public static let tab: UInt8 = 0x09

  public static let doubleQuote: UInt8 = 0x22

  public static let equal: UInt8 = 0x3D

  public static let slash: UInt8 = 0x2F

  public static let lessThan: UInt8 = 0x3C

  public static let greaterThan: UInt8 = 0x3E

  public static let openComment: ArraySlice<UInt8> =
    [0x3C, 0x2D, 0x2D, 0x20]

  public static let closeComment: ArraySlice<UInt8> =
    [0x20, 0x2D, 0x2D, 0x3E]

  public static let doubleQuoteReplacement: ArraySlice<UInt8> =
    [0x26, 0x71, 0x75, 0x6F, 0x74, 0x3B]

  public static let singleQuoteReplacement: ArraySlice<UInt8> =
    [0x26, 0x23, 0x33, 0x39, 0x3B]

  public static let ampersandReplacement: ArraySlice<UInt8> =
    [0x26, 0x61, 0x6D, 0x70, 0x3B]

  public static let lessThanReplacement: ArraySlice<UInt8> =
    [0x26, 0x6C, 0x74, 0x3B]

  public static let greaterThanReplacement: ArraySlice<UInt8> =
    [0x26, 0x67, 0x74, 0x3B]

  public static let closeCommentReplacement: ArraySlice<UInt8> =
    [0x2D, 0x2D, 0x26, 0x67, 0x74, 0x3B]

  public static let openDoctype: ArraySlice<UInt8> =
    [0x3C, 0x21, 0x44, 0x4F, 0x43, 0x54, 0x59, 0x50, 0x45, 0x20]

  @inlinable
  public static func <<< (lhs: HTMLByteStream, rhs: UInt8) -> HTMLByteStream {
    lhs._result.append(rhs)
    return lhs
  }

  @inlinable
  public static func <<< (lhs: HTMLByteStream, rhs: Slice) -> HTMLByteStream {
    lhs._result.append(contentsOf: rhs)
    return lhs
  }

  @inlinable
  public static func <<< <S: StringProtocol>(lhs: HTMLByteStream,
                                             rhs: S) -> HTMLByteStream {
    lhs._result.append(contentsOf: rhs.utf8)
    return lhs
  }

  @inlinable
  public static func <<< (lhs: HTMLByteStream, rhs: Character) -> HTMLByteStream {
    lhs._result.append(contentsOf: rhs.utf8)
    return lhs
  }
}


