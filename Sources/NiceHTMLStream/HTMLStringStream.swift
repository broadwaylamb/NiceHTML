public final class HTMLStringStream: HTMLOutputStream {

  @usableFromInline
  internal var _result: String

  @inlinable
  public var result: String { _result }

  @inlinable
  public init() {
    _result = ""
  }

  public typealias Element = Character

  public typealias Slice = Substring

  public static let space: Character = " "

  public static let newline: Character = "\n"

  public static let tab: Character = "\t"

  public static let doubleQuote: Character = "\""

  public static let equal: Character = "="

  public static let slash: Character = "/"

  public static let lessThan: Character = "<"

  public static let greaterThan: Character = ">"

  public static let openComment: Substring = "<-- "

  public static let closeComment: Substring = " -->"

  public static let doubleQuoteReplacement: Substring = "&quot;"

  public static let singleQuoteReplacement: Substring = "&#39;"

  public static let ampersandReplacement: Substring = "&amp;"

  public static let lessThanReplacement: Substring = "&lt;"

  public static let greaterThanReplacement: Substring = "&gt;"

  public static let closeCommentReplacement: Substring = "--&gt;"

  public static let openDoctype: Substring = "<!DOCTYPE "

  @inlinable
  public static func <<< (lhs: HTMLStringStream, rhs: Character) -> HTMLStringStream {
    lhs._result.append(rhs)
    return lhs
  }

  @inlinable
  public static func <<< (lhs: HTMLStringStream, rhs: Substring) -> HTMLStringStream {
    lhs._result.append(contentsOf: rhs)
    return lhs
  }

  @inlinable
  public static func <<< <S: StringProtocol>(lhs: HTMLStringStream,
                                             rhs: S) -> HTMLStringStream {
    lhs._result.append(contentsOf: rhs)
    return lhs
  }
}


