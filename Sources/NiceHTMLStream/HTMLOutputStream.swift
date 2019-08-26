precedencegroup WriteToStreamPrecedence {
  associativity: left
  higherThan: MultiplicationPrecedence
}

infix operator <<<: WriteToStreamPrecedence

public protocol HTMLOutputStream: AnyObject {

  associatedtype Element

  associatedtype Slice: Collection where Slice.Element == Element

  static var space: Element { get }

  static var tab: Element { get }

  static var newline: Element { get }

  static var doubleQuote: Element { get }

  static var equal: Element { get }

  static var slash: Element { get }

  static var lessThan: Element { get }

  static var greaterThan: Element { get }

  static var openComment: Slice { get }

  static var closeComment: Slice { get }

  static var doubleQuoteReplacement: Slice { get }

  static var singleQuoteReplacement: Slice { get }

  static var ampersandReplacement: Slice { get }

  static var lessThanReplacement: Slice { get }

  static var greaterThanReplacement: Slice { get }

  static var closeCommentReplacement: Slice { get }

  static var openDoctype: Slice { get }

  @discardableResult
  static func <<< (lhs: Self, rhs: Element) throws -> Self

  @discardableResult
  static func <<< (lhs: Self, rhs: Slice) throws -> Self

  @discardableResult
  static func <<< <S: StringProtocol>(lhs: Self, rhs: S) throws -> Self

  @discardableResult
  static func <<< (lhs: Self, rhs: Character) throws -> Self
}

extension HTMLOutputStream {

  @discardableResult
  @inlinable
  public static func <<< (lhs: Self, rhs: (Self) throws -> Void) rethrows -> Self {
    try rhs(lhs)
    return lhs
  }
}

@inlinable
public func space<OutputStream: HTMLOutputStream>(_ stream: OutputStream) throws -> Void {
  try stream <<< OutputStream.space
}

@inlinable
public func newline<OutputStream: HTMLOutputStream>(
  _ stream: OutputStream
) throws -> Void {
  try stream <<< OutputStream.newline
}

@inlinable
public func tab<OutputStream: HTMLOutputStream>(_ stream: OutputStream) throws -> Void {
  try stream <<< OutputStream.tab
}

@inlinable
public func repeatCharacter<OutputStream: HTMLOutputStream>(
  _ character: OutputStream.Element,
  count: Int
) -> (OutputStream) throws -> Void {
  { stream in
    for _ in 0 ..< count {
      try stream <<< character
    }
  }
}

@inlinable
public func indentWithSpaces<OutputStream: HTMLOutputStream>(
  _ count: Int
) -> (OutputStream) throws -> Void {
  repeatCharacter(OutputStream.space, count: count)
}

@inlinable
public func indentWithTabs<OutputStream: HTMLOutputStream>(
  _ count: Int
) -> (OutputStream) throws -> Void {
  repeatCharacter(OutputStream.tab, count: count)
}

@inlinable
public func doubleQuote<OutputStream: HTMLOutputStream>(
  _ stream: OutputStream
) throws -> Void {
  try stream <<< OutputStream.doubleQuote
}

@inlinable
public func equal<OutputStream: HTMLOutputStream>(_ stream: OutputStream) throws -> Void {
  try stream <<< OutputStream.equal
}

@inlinable
public func slash<OutputStream: HTMLOutputStream>(_ stream: OutputStream) throws -> Void {
  try stream <<< OutputStream.slash
}

@inlinable
public func lessThan<OutputStream: HTMLOutputStream>(
  _ stream: OutputStream
) throws -> Void {
  try stream <<< OutputStream.lessThan
}

@inlinable
public func greaterThan<OutputStream: HTMLOutputStream>(
  _ stream: OutputStream
) throws -> Void {
  try stream <<< OutputStream.greaterThan
}

@inlinable
public func openComment<OutputStream: HTMLOutputStream>(
  _ stream: OutputStream
) throws -> Void {
  try stream <<< OutputStream.openComment
}

@inlinable
public func closeComment<OutputStream: HTMLOutputStream>(
  _ stream: OutputStream
) throws -> Void {
  try stream <<< OutputStream.closeComment
}

@inlinable
public func openDoctype<OutputStream: HTMLOutputStream>(
  _ stream: OutputStream
) throws -> Void {
  try stream <<< OutputStream.openDoctype
}

@inlinable
public func tag<OutputStream: HTMLOutputStream, Attributes: Sequence>(
  _ name: String,
  attributes: Attributes
) -> (OutputStream) throws -> Void
  where Attributes.Element == (key: String, value: String?)
{
  { stream in
    try stream <<< lessThan <<< name
    for (key, value) in attributes {
      try stream <<< space <<< key
      if let value = value {
        try stream <<< equal <<< doubleQuote <<< attributeValue(value) <<< doubleQuote
      }
    }
    try stream <<< greaterThan
  }
}

@inlinable
public func closeTag<OutputStream: HTMLOutputStream>(
  _ name: String
) -> (OutputStream) throws -> Void {
  { stream in
    try stream <<< lessThan <<< slash <<< name <<< greaterThan
  }
}

@inlinable
public func comment<OutputStream: HTMLOutputStream>(
  _ comment: String
) -> (OutputStream) throws -> Void {
  { stream in
    try stream <<< openComment
               <<< escapeComment(comment)
               <<< closeComment
  }
}

@inlinable
public func doctype<OutputStream: HTMLOutputStream>(
  _ doctype: String
) -> (OutputStream) throws -> Void {
  { stream in
    try stream <<< openDoctype
               <<< escapeDoctype(doctype)
               <<< greaterThan
  }
}

@inlinable
public func text<OutputStream: HTMLOutputStream>(
  _ text: String
) -> (OutputStream) throws -> Void {
  { stream in
    for c in text {
      switch c {
      case "&":
        try stream <<< OutputStream.ampersandReplacement
      case "<":
        try stream <<< OutputStream.lessThanReplacement
      case ">":
        try stream <<< OutputStream.greaterThanReplacement
      default:
        try stream <<< c
      }
    }
  }
}

@inlinable
public func attributeValue<OutputStream: HTMLOutputStream>(
  _ value: String
) -> (OutputStream) throws -> Void {
  { stream in
    for c in value {
      switch c {
      case "\"":
        try stream <<< OutputStream.doubleQuoteReplacement
      case "'":
        try stream <<< OutputStream.singleQuoteReplacement
      default:
        try stream <<< c
      }
    }
  }
}

@inlinable
internal func escapeDoctype<OutputStream: HTMLOutputStream>(
  _ doctype: String
) -> (OutputStream) throws -> Void {
  { stream in
    for c in doctype {
      switch c {
      case ">":
        try stream <<< OutputStream.greaterThanReplacement
      default:
        try stream <<< c
      }
    }
  }
}

@inlinable
internal func escapeComment<OutputStream: HTMLOutputStream>(
  _ comment: String
) -> (OutputStream) throws -> Void {
  comment.replacing("-->", with: OutputStream.closeCommentReplacement)
}

extension String {

  /// Finds thefirst  index of `self` where `substring` begins. The search is started from `start`.
  /// Fills  `buffer` with the characters of `self` until `substring` is found.
  @inlinable
  internal func find<OutputStream: HTMLOutputStream>(
    _ substring: String,
    start: String.Index,
    stream: OutputStream
  ) throws -> String.Index? {
    for i in indices[start...] {
      if self[i...].hasPrefix(substring) {
        return i
      } else {
        try stream <<< self[i]
      }
    }
    return nil
  }

  @inlinable
  internal func replacing<OutputStream: HTMLOutputStream>(
    _ substring: String,
    with replacement: OutputStream.Slice
  ) -> (OutputStream) throws -> Void {
    { stream in
      if substring.isEmpty {
        return
      }

      let replacementCount = replacement.count
      var start = self.startIndex
      while let newStart = try self.find(substring, start: start, stream: stream) {
        start = newStart
        try stream <<< replacement

        if let nextStart = self.index(start,
                                      offsetBy: replacementCount,
                                      limitedBy: self.endIndex) {
          start = nextStart
        } else {
          return
        }
      }
    }
  }
}

