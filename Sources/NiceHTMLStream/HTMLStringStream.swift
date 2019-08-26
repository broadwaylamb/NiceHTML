public final class HTMLStringStream: HTMLOutputStream {

  public private(set) var result: String

  public init() {
    result = ""
  }

  public typealias Element = Character

  public typealias Slice = Substring

  public static let space: Character = " "

  public static var newline: Character = "\n"

  public static var tab: Character = "\t"

  public static let doubleQuote: Character = "\""

  public static var equal: Character = "="

  public static var slash: Character = "/"

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

  public static func <<< (lhs: HTMLStringStream, rhs: Character) -> HTMLStringStream {
    lhs.result.append(rhs)
    return lhs
  }

  public static func <<< (lhs: HTMLStringStream, rhs: Substring) -> HTMLStringStream {
    lhs.result.append(contentsOf: rhs)
    return lhs
  }

  public static func <<< <S: StringProtocol>(lhs: HTMLStringStream,
                                             rhs: S) -> HTMLStringStream {
    lhs.result.append(contentsOf: rhs)
    return lhs
  }
}


