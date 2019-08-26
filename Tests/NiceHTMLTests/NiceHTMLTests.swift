import XCTest
import NiceHTML
import NiceHTMLStream

final class NiceHTMLTests: XCTestCase {
  func testExample() {
    let doc = HTMLDocument(
      doctype: "html>wow!",
      node: .fragment([
        .comment("Hello to earthlings! <a> -->"),
        .element(name: "html",
                 attrs: [(key: "lang", value: "whatever\"")],
                 child: .fragment([
                   .element(name: "head", attrs: [], child: .fragment([
                     .element(name: "title", attrs: [], child: .text("Hello!!!&<>"))
                   ])),
                   .element(name: "body", attrs: [], child: .fragment([
                    .element(name: "p", attrs: [], child: .text("lorem")),
                    .element(name: "p", attrs: [], child: .text("ipsum")),
                    .element(name: "p",
                             attrs: [],
                             child: .element(name: "b",
                                             attrs: [],
                                             child: .text("dolor"))),
                    .text("sit"),
                    .text("amet<br>"),
                    .voidElement(name: "br", attrs: []),
                    .text("consectetur"),
                    .raw("""
                    consectetur <br>
                    adipiscing elit
                    <i>sed</i>
                    """)
                   ]))
                 ]))
      ])
    )
  }
}
